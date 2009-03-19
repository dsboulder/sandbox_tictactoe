# ActsAsRunnableCodeOnRails

module ActsAsRunnableCodeOnRails
  def self.codepress_js
    @codepress_js ||= File.read(File.join(File.dirname(__FILE__), "..", "javascripts", "codepress.js"))
  end

  def self.codepress_css
    @codepress_css ||= File.read(File.join(File.dirname(__FILE__), "..", "stylesheets", "codepress.css"))
  end

  def self.ruby_js
    @ruby_js ||= File.read(File.join(File.dirname(__FILE__), "..", "javascripts", "ruby.js"))
  end

  def self.ruby_css
    @ruby_css ||= File.read(File.join(File.dirname(__FILE__), "..", "stylesheets", "ruby.css"))
  end
  
  def self.engines(engine)
    @engines ||= {}
    @engines[engine] ||= File.read(File.join(File.dirname(__FILE__), "..", "javascripts", "engines", "#{engine}.js"))
  end

  module ViewHelpers
    def acts_as_runnable_code_syntax_highlight_for(runnable_code_class, options = {})
      tag("script", :src => url_for({:action => "#{runnable_code_class.to_s.underscore}_codepress_js"}.merge(options)), :type => "text/javascript")
    end
  end
  
  module ControllerHelpers
    def acts_as_runnable_code_syntax_highlight_actions_for(runnable_code_class, options = {})
      codePressPath = {:action => "#{runnable_code_class.to_s.underscore}_codepress"}.merge(options)
      codepress_css_hash = {:action => "#{runnable_code_class.to_s.underscore}_codepress_css"}.merge(options)
      engine_js_hash = {:action => "#{runnable_code_class.to_s.underscore}_engine_js"}.merge(options)
      syntax_css_hash = {:action => "#{runnable_code_class.to_s.underscore}_syntax_css"}.merge(options)
      syntax_js_hash = {:action => "#{runnable_code_class.to_s.underscore}_syntax_js"}.merge(options)
      

      
      class_eval_str =  <<-EOF
        def #{runnable_code_class.to_s.underscore}_codepress_js
          txt = ActsAsRunnableCodeOnRails.codepress_js.gsub("codepress.html", "codepress") + 
                  "\nCodePress.path = '\#{url_for(#{codePressPath.inspect})}'"
          render :text => txt, :content_type => "text/javascript"
        end
        
        def #{runnable_code_class.to_s.underscore}_codepress_css
          txt = ActsAsRunnableCodeOnRails.codepress_css
          render :text => txt, :content_type => "text/css"
        end        

        def #{runnable_code_class.to_s.underscore}_engine_js
          txt = ActsAsRunnableCodeOnRails.engines(params[:engine])
          render :text => txt, :content_type => "text/javascript"
        end        

        def #{runnable_code_class.to_s.underscore}_syntax_js
          txt = ActsAsRunnableCodeOnRails.ruby_js.gsub("SPECIAL_FUNCTIONS", "#{runnable_code_class.constantize.runnable_methods_no_object.values.flatten.empty? ? "SPECIAL_FUNCTIONS" : runnable_code_class.constantize.runnable_methods_no_object.values.flatten.uniq.join("|")}")
          render :text => txt, :content_type => "text/javascript"
        end        

        def #{runnable_code_class.to_s.underscore}_syntax_css
          txt = ActsAsRunnableCodeOnRails.ruby_css
          render :text => txt, :content_type => "text/css"
        end        
        
        def #{runnable_code_class.to_s.underscore}_codepress
          html_code = <<-CODE
            <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
            <html>
            <head>
            	<title>CodePress - Real Time Syntax Highlighting Editor written in JavaScript</title>
            	<meta name="description" content="CodePress - source code editor window" />

            	<script type="text/javascript">
            	var engine = 'older';
            	var ua = navigator.userAgent;
            	var ts = (new Date).getTime(); // timestamp to avoid cache
            	var lh = location.href;

            	if(ua.match('MSIE')) engine = 'msie';
            	else if(ua.match('KHTML')) engine = 'khtml'; 
            	else if(ua.match('Opera')) engine = 'opera'; 
            	else if(ua.match('Gecko')) engine = 'gecko';

            	document.write('<link type="text/css" href="\#{url_for(#{codepress_css_hash.inspect})}" rel="stylesheet" />');
            	document.write('<link type="text/css" href="\#{url_for(#{syntax_css_hash.inspect})}" rel="stylesheet" />');
            	document.write('<scr'+'ipt type="text/javascript" src="\#{url_for(#{engine_js_hash.inspect})}?engine='+engine+'"></scr'+'ipt>');
            	document.write('<scr'+'ipt type="text/javascript" src="\#{url_for(#{syntax_js_hash.inspect})}"></scr'+'ipt>');
            	</script>

            </head>

            <script type="text/javascript">
            if(engine == "msie" || engine == "gecko") document.write('<body><pre> </pre></body>');
            else if(engine == "opera") document.write('<body></body>');
            // else if(engine == "khtml") document.write('<body> </body>');
            </script>

            </html>          
          CODE
          render :text => html_code, :content_type => "text/html"
        end
      EOF
      
      class_eval class_eval_str
    end
  end  
end

# tag("script", :src => url_for(:action => "#{runnable_code_class.to_s.underscore}_syntax_highlight_js"), :type => "text/javascript") +
# tag("link",   :src => url_for(:action => "#{runnable_code_class.to_s.underscore}_syntax_highlight_css"), :type => "text/javascript")          
