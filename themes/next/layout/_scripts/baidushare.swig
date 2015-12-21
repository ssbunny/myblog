{% if theme.baidushare and page.title %}

<style type="text/css">
.bdsharebuttonbox a {
	border-bottom: none;
}
</style>
<div style="color:#999;">
    <span id="busuanzi_container_page_pv">
    	本文已被阅读
    	<span id="busuanzi_value_page_pv"></span>
    	次，若是感觉写得还不错就分享一下 :)
    </span>
</div>
<div class="bdsharebuttonbox">
	<a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间"></a>
	<a href="#" class="bds_tqq" data-cmd="tqq" title="分享到腾讯微博"></a>
	<a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a>
	<a href="#" class="bds_fbook" data-cmd="fbook" title="分享到Facebook"></a>
	<a href="#" class="bds_twi" data-cmd="twi" title="分享到Twitter"></a>
	<a href="#" class="bds_linkedin" data-cmd="linkedin" title="分享到linkedin"></a>
	<a href="#" class="bds_more" data-cmd="more"></a>
</div>
<script>
window._bd_share_config = {
	"common": { 
		"bdSnsKey": {},
		"bdText": "",
		"bdMini": "2",
		"bdMiniList": [
			"mshare", "weixin","renren",
			"tqf","tieba","douban","sqq","youdao",
		],
		"bdPic":"",
		"bdStyle":"1",
		"bdSize":"24"
	},
	"share":{}
};
with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
</script>

{% endif %}