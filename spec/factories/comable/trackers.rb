FactoryGirl.define do
  factory :tracker, class: Comable::Tracker do
    activated_flag true
    name 'Example Tracker'
    tracker_id 'UA-XXXXXXX-X'
    code <<-_EOS_
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', '{{ tracker_id }}', 'auto');
  ga('send', 'pageview');
</script>
    _EOS_
    place 'everywhere'
  end
end
