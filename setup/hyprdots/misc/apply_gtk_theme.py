from includes.logger import logger
import subprocess
from time import sleep


def apply_gtk_theme(spinner) -> bool:
    """Apply GTK theme using gtk_theme_manager."""
    logger.info("Applying GTK theme...")

    try:
        sleep(1)

        logger.info("Installing Catppuccin theme...")
        spinner.update_text("Downloading Catppuccin theme...")
        subprocess.run(
            ["catppuccin_theme_installer", "mocha", "blue"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        logger.info("Applying Catppuccin theme...")
        spinner.update_text("Applying Catppuccin theme...")
        subprocess.run(
            [
                "gtk_theme_manager",
                "-t",
                "catppuccin-mocha-blue-standard+default",
                "-i",
                "Tela-circle-dark",
                "-c",
                "Bibata-Original-Classic",
                "-s",
                "20",
                "-m",
                "prefer_dark",
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        spinner.success("GTK theme applied successfully.")
        return True

    except subprocess.CalledProcessError as e:
        logger.error(f"Command failed: {e.cmd} (exit code {e.returncode})")
        return False
    except Exception as e:
        logger.error(f"Unexpected error while applying GTK theme: {e}")
        return False
