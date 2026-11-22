
$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot

Write-Host "HackerRank GitHub Auto-Sync Started!" -ForegroundColor Green
Write-Host "Monitoring: $PSScriptRoot"
Write-Host "Press Ctrl+C to stop."

while ($true) {
    try {
        $changes = git status --porcelain

        if ($LASTEXITCODE -ne 0) {
            throw "Git status failed."
        }

        if ($changes) {
            Write-Host "Changes detected. Waiting for file saves..." -ForegroundColor Yellow

            Start-Sleep -Seconds 3

            $changes = git status --porcelain

            if ($changes) {
                git add -- .

                if ($LASTEXITCODE -ne 0) {
                    throw "Git add failed."
                }

                git diff --cached --quiet

                if ($LASTEXITCODE -eq 1) {
                    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

                    git commit -m "HackerRank: Update solutions - $date"

                    if ($LASTEXITCODE -ne 0) {
                        throw "Git commit failed."
                    }

                    git push origin HEAD

                    if ($LASTEXITCODE -ne 0) {
                        throw "Git push failed."
                    }

                    Write-Host "Successfully synced to GitHub!" -ForegroundColor Green
                }
            }
        }

        Start-Sleep -Seconds 2
    }
    catch {
        Write-Host "Sync error: $_" -ForegroundColor Red
        Start-Sleep -Seconds 10
    }
}
