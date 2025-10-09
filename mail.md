To receive emails from your Gmail account and deliver them to a local Linux mail spool (e.g., an mbox file like `/var/mail/yourusername` or a custom mbox), while restricted to outbound ports 80/443 (common in firewalled environments), you can't use standard IMAP/POP3 protocols (which require ports like 993 or 995). Instead, use the Gmail API, which operates entirely over HTTPS on port 443.

This approach involves:

- Enabling the Gmail API and setting up OAuth 2.0 authentication.
- Writing a Python script to poll for new emails, fetch their raw RFC 822 format, and append them to a local mbox file.
- Running the script periodically (e.g., via cron) to simulate delivery.

### Prerequisites

- Python 3.x installed on your Linux machine.
- Access to a Gmail account (enable 2FA and generate an app password if needed, but OAuth handles auth).
- Root or sudo access to write to `/var/mail/` (or use a user-owned mbox like `~/mbox`).

### Step 1: Enable Gmail API and Set Up Credentials

1. Go to the [Google Cloud Console](https://console.cloud.google.com/apis/library/gmail.googleapis.com).
2. Create a new project (or select an existing one).
3. Enable the Gmail API.
4. Go to "Credentials" > "Create Credentials" > "OAuth client ID" > Select "Desktop application".
5. Download the `credentials.json` file and place it in your script's directory.
6. Configure the OAuth consent screen (add your Gmail as a test user).

This setup uses OAuth 2.0 for secure, token-based access without exposing passwords.

### Step 2: Install Dependencies

Run:

```
pip install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

### Step 3: Python Script for Fetching and Delivering Emails

Save this as `gmail_to_mbox.py`. It authenticates, searches for unread emails (you can customize the query), fetches the raw message, decodes it, and appends to an mbox file. On first run, it opens a browser for OAuth approval (subsequent runs use saved tokens).

```python
import os
import pickle
import base64
from email import message_from_bytes
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import mailbox

# Configuration
SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']  # Read-only scope; add 'gmail.modify' if marking as read
CREDENTIALS_FILE = 'credentials.json'
TOKEN_FILE = 'token.pickle'
MBOX_PATH = '/var/mail/yourusername'  # Or '~/mbox' for user-owned
GMAIL_USER_ID = 'me'  # Or your email address
SEARCH_QUERY = 'is:unread'  # Customize: e.g., 'from:example.com', 'after:2025/10/01'

def authenticate_gmail():
    creds = None
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE, 'rb') as token:
            creds = pickle.load(token)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS_FILE, SCOPES)
            creds = flow.run_local_server(port=0)
        with open(TOKEN_FILE, 'wb') as token:
            pickle.dump(creds, token)
    return build('gmail', 'v1', credentials=creds)

def fetch_and_deliver(service):
    # List message IDs matching the query
    results = service.users().messages().list(userId=GMAIL_USER_ID, q=SEARCH_QUERY).execute()
    messages = results.get('messages', [])

    if not messages:
        print('No new emails found.')
        return

    mbox = mailbox.mbox(MBOX_PATH)
    for msg in messages:
        # Fetch raw RFC 822 message
        raw_msg = service.users().messages().get(userId=GMAIL_USER_ID, id=msg['id'], format='raw').execute()
        raw_data = base64.urlsafe_b64decode(raw_msg['raw'])

        # Parse to EmailMessage and append to mbox
        email_msg = message_from_bytes(raw_data)
        mbox.add(email_msg)

        # Optional: Mark as read
        # service.users().messages().modify(userId=GMAIL_USER_ID, id=msg['id'], body={'removeLabelIds': ['UNREAD']}).execute()

    mbox.close()
    print(f'Delivered {len(messages)} emails to {MBOX_PATH}')

if __name__ == '__main__':
    service = authenticate_gmail()
    fetch_and_deliver(service)
```

- **How it works**:
  - Authentication saves tokens to `token.pickle` for reuse.
  - `format='raw'` fetches the full RFC 822 email (base64url-encoded).
  - `mailbox.mbox` handles appending to the mbox file without duplicates.
  - Customize `SEARCH_QUERY` for filtering (Gmail search syntax: labels, dates, senders).
- Run it: `python gmail_to_mbox.py`. First run opens a browser; approve access.
- To mark emails as read after delivery, uncomment the modify line (requires broader scope).

### Step 4: Automate Delivery

Add to crontab (`crontab -e`) for polling every 5 minutes:

```
*/5 * * * * /usr/bin/python3 /path/to/gmail_to_mbox.py >> /var/log/gmail_fetch.log 2>&1
```

### Step 5: Access Local Mail

- Use `mail` or `mutt` to read `/var/mail/yourusername`.
- For system integration, configure your MTA (e.g., Postfix) to use the mbox if needed.

### Limitations and Tips

- Gmail API has quotas (e.g., 250 queries/minute); for high volume, batch requests.
- If you need to send replies locally, extend the script with `gmail.send` (add `https://www.googleapis.com/auth/gmail.send` to SCOPES).
- Test in a restricted network: The script only makes HTTPS calls to `gmail.googleapis.com`.
- For errors (e.g., OAuth issues), check logs or regenerate credentials.

This setup ensures all traffic uses port 443, bypassing email-specific port restrictions.
