getFileMetadata()
{
# Get file metadata
curl "https://api.anthropic.com/v1/files/$FILE_ID" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: files-api-2025-04-14"
}

ListFiles()
{
# List all files
curl "https://api.anthropic.com/v1/files" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: files-api-2025-04-14"
}


DeleteFile()
{
# Delete a file
curl -X DELETE "https://api.anthropic.com/v1/files/$FILE_ID" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: files-api-2025-04-14"
}

CreateExcel()
{
# Step 1: Use a Skill to create a file

# Step 1: Call API and save full response
RESPONSE=$(curl -s https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: code-execution-2025-08-25,skills-2025-10-02" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-opus-4-6",
    "max_tokens": 4096,
    "container": {
      "skills": [
        {"type": "anthropic", "skill_id": "xlsx", "version": "latest"}
      ]
    },
    "messages": [{
      "role": "user",
      "content": "Create an Excel file with a simple budget spreadsheet"
    }],
    "tools": [{
      "type": "code_execution_20250825",
      "name": "code_execution"
    }]
  }')

# DEBUG: Inspect the raw response structure
echo "=== RAW RESPONSE ==="
echo "$RESPONSE" | jq '.'

echo "Step 2: Extract file_id — files appear in tool result content blocks"
FILE_ID=$(echo "$RESPONSE" | jq -r '
  .content[]
  | select(.type == "tool_result" or .type == "bash_code_execution_tool_result")
  | .content[]?
  | select(.type == "file" or (.file_id? != null))
  | .file_id // .source.file_id
' 2>/dev/null | head -1)

echo "Fallback: broader search for any file_id in the response"
if [ -z "$FILE_ID" ]; then
  echo "FILE_ID is empty, Fallback: broader search for any file_id in the response"
  FILE_ID=$(echo "$RESPONSE" | jq -r '.. | .file_id? // empty' 2>/dev/null | head -1)
fi

echo "=== FILE ID: $FILE_ID ==="

if [ -z "$FILE_ID" ] || [ "$FILE_ID" = "null" ]; then
  echo "ERROR: No file_id found. Check raw response above."
  exit 1
fi

echo "Step 3: Get filename from metadata"
META=$(curl -s "https://api.anthropic.com/v1/files/$FILE_ID" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: files-api-2025-04-14")

echo "=== FILE META ==="
echo "$META" | jq '.'

FILENAME=$(echo "$META" | jq -r '.filename // "output.xlsx"')
echo "=== FILENAME: $FILENAME ==="

echo "Step 4: Download $FILENAME"
curl -s "https://api.anthropic.com/v1/files/$FILE_ID/content" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: files-api-2025-04-14" \
  --output "$FILENAME"

echo "Downloaded: $FILENAME"
}


### 
. $HOME/3d_processor/.keys
CreateExcel
ListFiles

