From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline
 declarations
Date: Tue, 05 Jun 2018 12:13:58 -0700
Message-ID: <5ad1876557235a089a50e6ed6c558a7dcb0da714.camel@perches.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
         <20180605170532.170361-2-ndesaulniers@google.com>
         <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, caoj.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, hpa@zytor.com, jan.kiszka@siemens.com, jarkko.sakkinen@linux.intel.com, jgross@suse.com, jpoimboe@redhat.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, mka@chromium.org, pombredanne@nexb.com, rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, tweek@google.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux-foundation.org, astrachan@google.com, manojgupta@google.com, ghackmann@google.com, sedat.dilek@gmail.com, tstellar@redhat.com, keescook@google.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, linux-kbuild@vger.kernel.org, geert@linux-m68k.org, will.deacon@arm.com, mawilcox@microsoft.com, arnd@arndb.de, rientjes@google.com
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-06-05 at 10:23 -0700, Joe Perches wrote:
> Perhaps these are simpler as
> 
> #define __inline__	inline
> #define __inline	inline

Currently, there are these uses of inline variants in the kernel

$ git grep -w inline | wc -l
68410
$ git grep -w __inline__ | wc -l
503
$ git grep -w __inline | wc -l
57

So it seems it's also reasonable to sed all uses of __inline to inline
and perhaps remove __inline eventually altogether.
(perhaps there are still too many __inline__ uses)

Excluding scripts and a few other files,
here's a possible patch done with:

$ git grep -w --name-only __inline | \
  grep -vP '^(?:arch/alpha/|include/|scripts/)' | \
  xargs sed -r -i -e 's/\b__inline\b/inline/g' \
                  -e 's/\binline\s+static\b/static inline/g'
---
 Documentation/trace/tracepoint-analysis.rst             |  2 +-
 drivers/staging/rtl8723bs/core/rtw_pwrctrl.c            |  4 ++--
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c          |  2 +-
 drivers/staging/rtl8723bs/include/drv_types.h           |  6 +++---
 drivers/staging/rtl8723bs/include/ieee80211.h           |  6 +++---
 drivers/staging/rtl8723bs/include/osdep_service.h       | 10 +++++-----
 drivers/staging/rtl8723bs/include/osdep_service_linux.h | 14 +++++++-------
 drivers/staging/rtl8723bs/include/rtw_mlme.h            | 14 +++++++-------
 drivers/staging/rtl8723bs/include/rtw_recv.h            | 16 ++++++++--------
 drivers/staging/rtl8723bs/include/sta_info.h            |  2 +-
 drivers/staging/rtl8723bs/include/wifi.h                | 14 +++++++-------
 drivers/staging/rtl8723bs/include/wlan_bssdef.h         |  2 +-
 lib/zstd/mem.h                                          |  2 +-
 13 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/Documentation/trace/tracepoint-analysis.rst b/Documentation/trace/tracepoint-analysis.rst
index a4d3ff2e5efb..310f4c579cff 100644
--- a/Documentation/trace/tracepoint-analysis.rst
+++ b/Documentation/trace/tracepoint-analysis.rst
@@ -315,7 +315,7 @@ To see where within the function pixmanFillsse2 things are going wrong:
     0.00 :         34eeb:       0f 18 08                prefetcht0 (%eax)
          :      }
          :
-         :      extern __inline void __attribute__((__gnu_inline__, __always_inline__, _
+         :      extern inline void __attribute__((__gnu_inline__, __always_inline__, _
          :      _mm_store_si128 (__m128i *__P, __m128i __B) :      {
          :        *__P = __B;
    12.40 :         34eee:       66 0f 7f 80 40 ff ff    movdqa %xmm0,-0xc0(%eax)
diff --git a/drivers/staging/rtl8723bs/core/rtw_pwrctrl.c b/drivers/staging/rtl8723bs/core/rtw_pwrctrl.c
index 85f7769ecc2d..811492e64350 100644
--- a/drivers/staging/rtl8723bs/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8723bs/core/rtw_pwrctrl.c
@@ -839,12 +839,12 @@ static void pwr_rpwm_timeout_handler(struct timer_list *t)
 	_set_workitem(&pwrpriv->rpwmtimeoutwi);
 }
 
-static __inline void register_task_alive(struct pwrctrl_priv *pwrctrl, u32 tag)
+static inline void register_task_alive(struct pwrctrl_priv *pwrctrl, u32 tag)
 {
 	pwrctrl->alives |= tag;
 }
 
-static __inline void unregister_task_alive(struct pwrctrl_priv *pwrctrl, u32 tag)
+static inline void unregister_task_alive(struct pwrctrl_priv *pwrctrl, u32 tag)
 {
 	pwrctrl->alives &= ~tag;
 }
diff --git a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
index f6dc26c8bd3d..4e16087ef815 100644
--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -493,7 +493,7 @@ void set_channel_bwmode(struct adapter *padapter, unsigned char channel, unsigne
 	mutex_unlock(&(adapter_to_dvobj(padapter)->setch_mutex));
 }
 
-__inline u8 *get_my_bssid(struct wlan_bssid_ex *pnetwork)
+inline u8 *get_my_bssid(struct wlan_bssid_ex *pnetwork)
 {
 	return pnetwork->MacAddress;
 }
diff --git a/drivers/staging/rtl8723bs/include/drv_types.h b/drivers/staging/rtl8723bs/include/drv_types.h
index 16b81b1a3f33..5d487243a822 100644
--- a/drivers/staging/rtl8723bs/include/drv_types.h
+++ b/drivers/staging/rtl8723bs/include/drv_types.h
@@ -493,7 +493,7 @@ struct dvobj_priv
 #define dvobj_to_pwrctl(dvobj) (&(dvobj->pwrctl_priv))
 #define pwrctl_to_dvobj(pwrctl) container_of(pwrctl, struct dvobj_priv, pwrctl_priv)
 
-__inline static struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
+static inline struct device *dvobj_to_dev(struct dvobj_priv *dvobj)
 {
 	/* todo: get interface type from dvobj and the return the dev accordingly */
 #ifdef RTW_DVOBJ_CHIP_HW_TYPE
@@ -651,14 +651,14 @@ struct adapter {
 
 /* define RTW_DISABLE_FUNC(padapter, func) (atomic_add(&adapter_to_dvobj(padapter)->disable_func, (func))) */
 /* define RTW_ENABLE_FUNC(padapter, func) (atomic_sub(&adapter_to_dvobj(padapter)->disable_func, (func))) */
-__inline static void RTW_DISABLE_FUNC(struct adapter *padapter, int func_bit)
+static inline void RTW_DISABLE_FUNC(struct adapter *padapter, int func_bit)
 {
 	int	df = atomic_read(&adapter_to_dvobj(padapter)->disable_func);
 	df |= func_bit;
 	atomic_set(&adapter_to_dvobj(padapter)->disable_func, df);
 }
 
-__inline static void RTW_ENABLE_FUNC(struct adapter *padapter, int func_bit)
+static inline void RTW_ENABLE_FUNC(struct adapter *padapter, int func_bit)
 {
 	int	df = atomic_read(&adapter_to_dvobj(padapter)->disable_func);
 	df &= ~(func_bit);
diff --git a/drivers/staging/rtl8723bs/include/ieee80211.h b/drivers/staging/rtl8723bs/include/ieee80211.h
index c8e5251c2760..78a4f2d836ce 100644
--- a/drivers/staging/rtl8723bs/include/ieee80211.h
+++ b/drivers/staging/rtl8723bs/include/ieee80211.h
@@ -858,18 +858,18 @@ enum ieee80211_state {
 #define IP_FMT "%pI4"
 #define IP_ARG(x) (x)
 
-extern __inline int is_multicast_mac_addr(const u8 *addr)
+extern inline int is_multicast_mac_addr(const u8 *addr)
 {
         return ((addr[0] != 0xff) && (0x01 & addr[0]));
 }
 
-extern __inline int is_broadcast_mac_addr(const u8 *addr)
+extern inline int is_broadcast_mac_addr(const u8 *addr)
 {
 	return ((addr[0] == 0xff) && (addr[1] == 0xff) && (addr[2] == 0xff) &&   \
 		(addr[3] == 0xff) && (addr[4] == 0xff) && (addr[5] == 0xff));
 }
 
-extern __inline int is_zero_mac_addr(const u8 *addr)
+extern inline int is_zero_mac_addr(const u8 *addr)
 {
 	return ((addr[0] == 0x00) && (addr[1] == 0x00) && (addr[2] == 0x00) &&   \
 		(addr[3] == 0x00) && (addr[4] == 0x00) && (addr[5] == 0x00));
diff --git a/drivers/staging/rtl8723bs/include/osdep_service.h b/drivers/staging/rtl8723bs/include/osdep_service.h
index e62ed71e1d80..ffaf9e366364 100644
--- a/drivers/staging/rtl8723bs/include/osdep_service.h
+++ b/drivers/staging/rtl8723bs/include/osdep_service.h
@@ -118,12 +118,12 @@ int _rtw_netif_rx(_nic_hdl ndev, struct sk_buff *skb);
 
 extern void _rtw_init_queue(struct __queue	*pqueue);
 
-static __inline void thread_enter(char *name)
+static inline void thread_enter(char *name)
 {
 	allow_signal(SIGTERM);
 }
 
-__inline static void flush_signals_thread(void)
+static inline void flush_signals_thread(void)
 {
 	if (signal_pending (current))
 	{
@@ -133,7 +133,7 @@ __inline static void flush_signals_thread(void)
 
 #define rtw_warn_on(condition) WARN_ON(condition)
 
-__inline static int rtw_bug_check(void *parg1, void *parg2, void *parg3, void *parg4)
+static inline int rtw_bug_check(void *parg1, void *parg2, void *parg3, void *parg4)
 {
 	int ret = true;
 
@@ -144,7 +144,7 @@ __inline static int rtw_bug_check(void *parg1, void *parg2, void *parg3, void *p
 #define _RND(sz, r) ((((sz)+((r)-1))/(r))*(r))
 #define RND4(x)	(((x >> 2) + (((x & 3) == 0) ?  0: 1)) << 2)
 
-__inline static u32 _RND4(u32 sz)
+static inline u32 _RND4(u32 sz)
 {
 
 	u32 val;
@@ -155,7 +155,7 @@ __inline static u32 _RND4(u32 sz)
 
 }
 
-__inline static u32 _RND8(u32 sz)
+static inline u32 _RND8(u32 sz)
 {
 
 	u32 val;
diff --git a/drivers/staging/rtl8723bs/include/osdep_service_linux.h b/drivers/staging/rtl8723bs/include/osdep_service_linux.h
index 711863d74a01..a8d5456d7f85 100644
--- a/drivers/staging/rtl8723bs/include/osdep_service_linux.h
+++ b/drivers/staging/rtl8723bs/include/osdep_service_linux.h
@@ -74,12 +74,12 @@
 
 	typedef struct work_struct _workitem;
 
-__inline static struct list_head *get_next(struct list_head	*list)
+static inline struct list_head *get_next(struct list_head	*list)
 {
 	return list->next;
 }
 
-__inline static struct list_head	*get_list_head(struct __queue	*queue)
+static inline struct list_head	*get_list_head(struct __queue	*queue)
 {
 	return (&(queue->queue));
 }
@@ -88,28 +88,28 @@ __inline static struct list_head	*get_list_head(struct __queue	*queue)
 #define LIST_CONTAINOR(ptr, type, member) \
 	container_of(ptr, type, member)
 
-__inline static void _set_timer(_timer *ptimer, u32 delay_time)
+static inline void _set_timer(_timer *ptimer, u32 delay_time)
 {
 	mod_timer(ptimer , (jiffies+(delay_time*HZ/1000)));
 }
 
-__inline static void _cancel_timer(_timer *ptimer, u8 *bcancelled)
+static inline void _cancel_timer(_timer *ptimer, u8 *bcancelled)
 {
 	del_timer_sync(ptimer);
 	*bcancelled =  true;/* true == 1; false == 0 */
 }
 
-__inline static void _init_workitem(_workitem *pwork, void *pfunc, void *cntx)
+static inline void _init_workitem(_workitem *pwork, void *pfunc, void *cntx)
 {
 	INIT_WORK(pwork, pfunc);
 }
 
-__inline static void _set_workitem(_workitem *pwork)
+static inline void _set_workitem(_workitem *pwork)
 {
 	schedule_work(pwork);
 }
 
-__inline static void _cancel_workitem_sync(_workitem *pwork)
+static inline void _cancel_workitem_sync(_workitem *pwork)
 {
 	cancel_work_sync(pwork);
 }
diff --git a/drivers/staging/rtl8723bs/include/rtw_mlme.h b/drivers/staging/rtl8723bs/include/rtw_mlme.h
index 2e4f12b54929..40af3a34ed05 100644
--- a/drivers/staging/rtl8723bs/include/rtw_mlme.h
+++ b/drivers/staging/rtl8723bs/include/rtw_mlme.h
@@ -533,13 +533,13 @@ extern sint rtw_select_and_join_from_scanned_queue(struct mlme_priv *pmlmepriv);
 extern sint rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, sint keyid, u8 set_tx, bool enqueue);
 extern sint rtw_set_auth(struct adapter *adapter, struct security_priv *psecuritypriv);
 
-__inline static u8 *get_bssid(struct mlme_priv *pmlmepriv)
+static inline u8 *get_bssid(struct mlme_priv *pmlmepriv)
 {	/* if sta_mode:pmlmepriv->cur_network.network.MacAddress => bssid */
 	/*  if adhoc_mode:pmlmepriv->cur_network.network.MacAddress => ibss mac address */
 	return pmlmepriv->cur_network.network.MacAddress;
 }
 
-__inline static sint check_fwstate(struct mlme_priv *pmlmepriv, sint state)
+static inline sint check_fwstate(struct mlme_priv *pmlmepriv, sint state)
 {
 	if (pmlmepriv->fw_state & state)
 		return true;
@@ -547,7 +547,7 @@ __inline static sint check_fwstate(struct mlme_priv *pmlmepriv, sint state)
 	return false;
 }
 
-__inline static sint get_fwstate(struct mlme_priv *pmlmepriv)
+static inline sint get_fwstate(struct mlme_priv *pmlmepriv)
 {
 	return pmlmepriv->fw_state;
 }
@@ -559,7 +559,7 @@ __inline static sint get_fwstate(struct mlme_priv *pmlmepriv)
  * ### NOTE:#### (!!!!)
  * MUST TAKE CARE THAT BEFORE CALLING THIS FUNC, YOU SHOULD HAVE LOCKED pmlmepriv->lock
  */
-__inline static void set_fwstate(struct mlme_priv *pmlmepriv, sint state)
+static inline void set_fwstate(struct mlme_priv *pmlmepriv, sint state)
 {
 	pmlmepriv->fw_state |= state;
 	/* FOR HW integration */
@@ -568,7 +568,7 @@ __inline static void set_fwstate(struct mlme_priv *pmlmepriv, sint state)
 	}
 }
 
-__inline static void _clr_fwstate_(struct mlme_priv *pmlmepriv, sint state)
+static inline void _clr_fwstate_(struct mlme_priv *pmlmepriv, sint state)
 {
 	pmlmepriv->fw_state &= ~state;
 	/* FOR HW integration */
@@ -581,7 +581,7 @@ __inline static void _clr_fwstate_(struct mlme_priv *pmlmepriv, sint state)
  * No Limit on the calling context,
  * therefore set it to be the critical section...
  */
-__inline static void clr_fwstate(struct mlme_priv *pmlmepriv, sint state)
+static inline void clr_fwstate(struct mlme_priv *pmlmepriv, sint state)
 {
 	spin_lock_bh(&pmlmepriv->lock);
 	if (check_fwstate(pmlmepriv, state) == true)
@@ -589,7 +589,7 @@ __inline static void clr_fwstate(struct mlme_priv *pmlmepriv, sint state)
 	spin_unlock_bh(&pmlmepriv->lock);
 }
 
-__inline static void set_scanned_network_val(struct mlme_priv *pmlmepriv, sint val)
+static inline void set_scanned_network_val(struct mlme_priv *pmlmepriv, sint val)
 {
 	spin_lock_bh(&pmlmepriv->lock);
 	pmlmepriv->num_of_scanned = val;
diff --git a/drivers/staging/rtl8723bs/include/rtw_recv.h b/drivers/staging/rtl8723bs/include/rtw_recv.h
index d4986f5685c5..eac0c4870dd4 100644
--- a/drivers/staging/rtl8723bs/include/rtw_recv.h
+++ b/drivers/staging/rtl8723bs/include/rtw_recv.h
@@ -413,7 +413,7 @@ struct recv_buf *rtw_dequeue_recvbuf (struct __queue *queue);
 
 void rtw_reordering_ctrl_timeout_handler(struct timer_list *t);
 
-__inline static u8 *get_rxmem(union recv_frame *precvframe)
+static inline u8 *get_rxmem(union recv_frame *precvframe)
 {
 	/* always return rx_head... */
 	if (precvframe == NULL)
@@ -422,7 +422,7 @@ __inline static u8 *get_rxmem(union recv_frame *precvframe)
 	return precvframe->u.hdr.rx_head;
 }
 
-__inline static u8 *get_recvframe_data(union recv_frame *precvframe)
+static inline u8 *get_recvframe_data(union recv_frame *precvframe)
 {
 
 	/* alwasy return rx_data */
@@ -433,7 +433,7 @@ __inline static u8 *get_recvframe_data(union recv_frame *precvframe)
 
 }
 
-__inline static u8 *recvframe_pull(union recv_frame *precvframe, sint sz)
+static inline u8 *recvframe_pull(union recv_frame *precvframe, sint sz)
 {
 	/*  rx_data += sz; move rx_data sz bytes  hereafter */
 
@@ -458,7 +458,7 @@ __inline static u8 *recvframe_pull(union recv_frame *precvframe, sint sz)
 
 }
 
-__inline static u8 *recvframe_put(union recv_frame *precvframe, sint sz)
+static inline u8 *recvframe_put(union recv_frame *precvframe, sint sz)
 {
 	/*  rx_tai += sz; move rx_tail sz bytes  hereafter */
 
@@ -487,7 +487,7 @@ __inline static u8 *recvframe_put(union recv_frame *precvframe, sint sz)
 
 
 
-__inline static u8 *recvframe_pull_tail(union recv_frame *precvframe, sint sz)
+static inline u8 *recvframe_pull_tail(union recv_frame *precvframe, sint sz)
 {
 	/*  rmv data from rx_tail (by yitsen) */
 
@@ -511,7 +511,7 @@ __inline static u8 *recvframe_pull_tail(union recv_frame *precvframe, sint sz)
 
 }
 
-__inline static union recv_frame *rxmem_to_recvframe(u8 *rxmem)
+static inline union recv_frame *rxmem_to_recvframe(u8 *rxmem)
 {
 	/* due to the design of 2048 bytes alignment of recv_frame, we can reference the union recv_frame */
 	/* from any given member of recv_frame. */
@@ -521,13 +521,13 @@ __inline static union recv_frame *rxmem_to_recvframe(u8 *rxmem)
 
 }
 
-__inline static sint get_recvframe_len(union recv_frame *precvframe)
+static inline sint get_recvframe_len(union recv_frame *precvframe)
 {
 	return precvframe->u.hdr.len;
 }
 
 
-__inline static s32 translate_percentage_to_dbm(u32 SignalStrengthIndex)
+static inline s32 translate_percentage_to_dbm(u32 SignalStrengthIndex)
 {
 	s32	SignalPower; /*  in dBm. */
 
diff --git a/drivers/staging/rtl8723bs/include/sta_info.h b/drivers/staging/rtl8723bs/include/sta_info.h
index 84fa116fc5da..c1f7b9eed611 100644
--- a/drivers/staging/rtl8723bs/include/sta_info.h
+++ b/drivers/staging/rtl8723bs/include/sta_info.h
@@ -356,7 +356,7 @@ struct	sta_priv {
 };
 
 
-__inline static u32 wifi_mac_hash(u8 *mac)
+static inline u32 wifi_mac_hash(u8 *mac)
 {
         u32 x;
 
diff --git a/drivers/staging/rtl8723bs/include/wifi.h b/drivers/staging/rtl8723bs/include/wifi.h
index 530d698f50d9..475f2e07ad02 100644
--- a/drivers/staging/rtl8723bs/include/wifi.h
+++ b/drivers/staging/rtl8723bs/include/wifi.h
@@ -355,7 +355,7 @@ enum WIFI_REG_DOMAIN {
 	(addr[4] == 0xff) && (addr[5] == 0xff))  ? true : false \
 )
 
-__inline static int IS_MCAST(unsigned char *da)
+static inline int IS_MCAST(unsigned char *da)
 {
 	if ((*da) & 0x01)
 		return true;
@@ -363,20 +363,20 @@ __inline static int IS_MCAST(unsigned char *da)
 		return false;
 }
 
-__inline static unsigned char * get_ra(unsigned char *pframe)
+static inline unsigned char * get_ra(unsigned char *pframe)
 {
 	unsigned char *ra;
 	ra = GetAddr1Ptr(pframe);
 	return ra;
 }
-__inline static unsigned char * get_ta(unsigned char *pframe)
+static inline unsigned char * get_ta(unsigned char *pframe)
 {
 	unsigned char *ta;
 	ta = GetAddr2Ptr(pframe);
 	return ta;
 }
 
-__inline static unsigned char * get_da(unsigned char *pframe)
+static inline unsigned char * get_da(unsigned char *pframe)
 {
 	unsigned char *da;
 	unsigned int	to_fr_ds	= (GetToDs(pframe) << 1) | GetFrDs(pframe);
@@ -400,7 +400,7 @@ __inline static unsigned char * get_da(unsigned char *pframe)
 }
 
 
-__inline static unsigned char * get_sa(unsigned char *pframe)
+static inline unsigned char * get_sa(unsigned char *pframe)
 {
 	unsigned char *sa;
 	unsigned int	to_fr_ds	= (GetToDs(pframe) << 1) | GetFrDs(pframe);
@@ -423,7 +423,7 @@ __inline static unsigned char * get_sa(unsigned char *pframe)
 	return sa;
 }
 
-__inline static unsigned char * get_hdr_bssid(unsigned char *pframe)
+static inline unsigned char * get_hdr_bssid(unsigned char *pframe)
 {
 	unsigned char *sa = NULL;
 	unsigned int	to_fr_ds	= (GetToDs(pframe) << 1) | GetFrDs(pframe);
@@ -447,7 +447,7 @@ __inline static unsigned char * get_hdr_bssid(unsigned char *pframe)
 }
 
 
-__inline static int IsFrameTypeCtrl(unsigned char *pframe)
+static inline int IsFrameTypeCtrl(unsigned char *pframe)
 {
 	if (WIFI_CTRL_TYPE == GetFrameType(pframe))
 		return true;
diff --git a/drivers/staging/rtl8723bs/include/wlan_bssdef.h b/drivers/staging/rtl8723bs/include/wlan_bssdef.h
index af78d97980fa..767c444acc54 100644
--- a/drivers/staging/rtl8723bs/include/wlan_bssdef.h
+++ b/drivers/staging/rtl8723bs/include/wlan_bssdef.h
@@ -231,7 +231,7 @@ struct wlan_bssid_ex {
 	u8  IEs[MAX_IE_SZ];	/* timestamp, beacon interval, and capability information) */
 } __packed;
 
-__inline  static uint get_wlan_bssid_ex_sz(struct wlan_bssid_ex *bss)
+static inline uint get_wlan_bssid_ex_sz(struct wlan_bssid_ex *bss)
 {
 	return (sizeof(struct wlan_bssid_ex) - MAX_IE_SZ + bss->IELength);
 }
diff --git a/lib/zstd/mem.h b/lib/zstd/mem.h
index 3a0f34c8706c..739837a59ad6 100644
--- a/lib/zstd/mem.h
+++ b/lib/zstd/mem.h
@@ -27,7 +27,7 @@
 /*-****************************************
 *  Compiler specifics
 ******************************************/
-#define ZSTD_STATIC static __inline __attribute__((unused))
+#define ZSTD_STATIC static inline __attribute__((unused))
 
 /*-**************************************************************
 *  Basic Types
