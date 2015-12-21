<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; &nbsp; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="icon-next-heart"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
  <span>&nbsp;&nbsp;&nbsp;(感谢 Github 、 Hexo 、 NexT 的支持。）</span>
</div>

<div>
  <span id="busuanzi_container_site_pv">
    您是本站的第 <span style="color:green" id="busuanzi_value_site_uv"></span> 位访客，
    我可怜的博客已被猛戳了 <span style="color:green" id="busuanzi_value_site_pv"></span> 下。
  </span>
</div>

{% block footer %}{% endblock %}
