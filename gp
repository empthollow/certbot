#!/bin/bash
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
	git add . && git status && echo "[press enter to continue]" && read -p "comment> " comment && git commit -m "$comment" && git push origin main
else
	echo "authentication failed"
fi