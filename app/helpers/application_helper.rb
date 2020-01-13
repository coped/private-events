module ApplicationHelper
    def full_title(page_title = "")
        base = "Private Events"
        page_title.empty? ? base : page_title + " | " + base
    end

    def event_date_in_words(event)
        "#{time_ago_in_words(event.date)} #{event.date > Time.now ? "from now" : "ago"}"
    end
end
