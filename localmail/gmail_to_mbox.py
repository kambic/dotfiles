import os
import pickle
import base64
from email import message_from_bytes
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import mailbox

# Configuration
SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly"
]  # Read-only scope; add 'gmail.modify' if marking as read
CREDENTIALS_FILE = "credentials.json"
TOKEN_FILE = "token.pickle"
MBOX_PATH = "/var/mail/yourusername"  # Or '~/mbox' for user-owned
GMAIL_USER_ID = "me"  # Or your email address
SEARCH_QUERY = "is:unread"  # Customize: e.g., 'from:example.com', 'after:2025/10/01'


def authenticate_gmail():
    creds = None
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE, "rb") as token:
            creds = pickle.load(token)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDENTIALS_FILE, SCOPES)
            creds = flow.run_local_server(port=0)
        with open(TOKEN_FILE, "wb") as token:
            pickle.dump(creds, token)
    return build("gmail", "v1", credentials=creds)


def fetch_and_deliver(service):
    # List message IDs matching the query
    results = (
        service.users().messages().list(userId=GMAIL_USER_ID, q=SEARCH_QUERY).execute()
    )
    messages = results.get("messages", [])

    if not messages:
        print("No new emails found.")
        return

    mbox = mailbox.mbox(MBOX_PATH)
    for msg in messages:
        # Fetch raw RFC 822 message
        raw_msg = (
            service.users()
            .messages()
            .get(userId=GMAIL_USER_ID, id=msg["id"], format="raw")
            .execute()
        )
        raw_data = base64.urlsafe_b64decode(raw_msg["raw"])

        # Parse to EmailMessage and append to mbox
        email_msg = message_from_bytes(raw_data)
        mbox.add(email_msg)

        # Optional: Mark as read
        # service.users().messages().modify(userId=GMAIL_USER_ID, id=msg['id'], body={'removeLabelIds': ['UNREAD']}).execute()

    mbox.close()
    print(f"Delivered {len(messages)} emails to {MBOX_PATH}")


if __name__ == "__main__":
    service = authenticate_gmail()
    fetch_and_deliver(service)
