module ApplicationHelper
    def full_title(page_title = "")
        base = "Private Events"
        page_title.empty? ? base : page_title + " | " + base
    end
end
