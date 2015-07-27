module Gridium
  class Page

    def initialize

    end

    def self.switch_to_frame(frame)
      Driver.driver.switch_to.frame(frame)
    end

    def self.switch_to_default
      Driver.driver.switch_to.default_content
    end

    def self.assert_selector(by, locator)
      asserted_element = Element.new("Asserted Element", by, locator)
      unless asserted_element.enabled?
        fail("Could not find element on page with locator #{locator} using #{by}")
      else
        Log.info("Asserted Element present with locator #{locator} using #{by}")
      end
    end

    def self.has_css?(css, options={})
      begin
        Driver.driver.find_element(:css, css).enabled?
      rescue Exception => e
        return false
      end
    end

    def self.has_xpath?(xpath, options={})
      begin
        Driver.driver.find_element(:xpath, xpath).enabled?
      rescue Exception => e
        return false
      end

    end

    def self.has_link?(linktext)
      begin
        Driver.driver.find_element(:link_text, linktext).enabled?
      rescue Exception => e
        return false
      end
    end

    def self.has_text?(text)
      unless Driver.html.include? text
        Log.warn("Could not find expected text: #{text} on page.")
        return false
      else
        return true
      end
    end

    def self.scroll_to_bottom
      Driver.execute_script('window.scrollTo(0,100000)')
    end

    def self.scroll_to_top
      #TODO Verify this
      Driver.execute_script('window.scrollTo(100000,0)')
    end

    def self.execute_script(script)
      Driver.execute_script(script)
    end

    def all(by, locator)
      Driver.driver.find_elements(by, locator)
    end

    def find(by, locator)
      Element.new("Page Find Element", by, locator)
    end

    def first(by, locator)
      Driver.driver.find_elements(by, locator).first
    end

    def click_link(linktext)
      link = Driver.driver.find_element(:link, linktext)
      link.click
    end

    def click_button(button_name)
      #The button maybe a link that looks like a button - we want to handle both
      button = Element.new("A #{button_name} button", :xpath, "//button[contains(text(), '#{button_name}')]")
      begin
        button.click
      rescue Exception => e
        Log.debug("Button not found - Attempting Link - speed up test by using click_link method if this works...")
        link = Element.new("A #{button_name} link", :xpath, "//a[contains(text(), '#{button_name}')]")
        link.click
      end
    end

    def check(id) #checks a checkbox
      Driver.driver.find_element(:id, id).click
    end

  end
end