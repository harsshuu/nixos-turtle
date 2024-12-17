# ~/.config/ytfzf/conf.sh

# Set mpv as the default player
YTFZF_PLAYER="mpv"

# Enable thumbnail previews for search results
YTFZF_THUMBNAILS=true

# Use yt-dlp for downloads
YTFZF_DL_CMD="yt-dlp"

# Default number of search results
YTFZF_DEFAULT_RESULTS=50

# Customize the download directory and output format
YTFZF_DL_OPTS="-o /home/turtle/dl/%(title)s.%(ext)s"
