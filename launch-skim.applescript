on run argv
	tell application "Skim"
		activate
		set pdfName to item 1 of argv
		set myPageNumber to item 2 of argv
		set myDoc to open pdfName
		set myPages to (get pages for myDoc)
		set myPage to item myPageNumber of myPages
		tell myDoc
			set current page to myPage
			tell view settings
				--set auto scales to true
				--set scale factor to 3.0
			end tell
		end tell
	end tell
end run