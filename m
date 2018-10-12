From: Dmitry Safonov <dima@arista.com>
Subject: [RFC-resend 2/2] compat: Cleanup in_compat_syscall() callers
Date: Fri, 12 Oct 2018 14:42:53 +0100
Message-ID: <20181012134253.23266-3-dima@arista.com>
References: <20181012134253.23266-1-dima@arista.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181012134253.23266-1-dima@arista.com>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirsky <luto@kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>, Steffen Klassert <steffen.klassert@secunet.com>, Stephen Boyd <sboyd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, linux-efi@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Now that in_compat_syscall() == false on native i686, it's possible to
remove some ifdeffery and no more needed helpers.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 drivers/firmware/efi/efivars.c | 16 ++++------------
 kernel/time/time.c             |  2 +-
 net/xfrm/xfrm_state.c          |  2 --
 net/xfrm/xfrm_user.c           |  2 --
 4 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 3e626fd9bd4e..8061667a6765 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -229,14 +229,6 @@ sanity_check(struct efi_variable *var, efi_char16_t *name, efi_guid_t vendor,
 	return 0;
 }
 
-static inline bool is_compat(void)
-{
-	if (IS_ENABLED(CONFIG_COMPAT) && in_compat_syscall())
-		return true;
-
-	return false;
-}
-
 static void
 copy_out_compat(struct efi_variable *dst, struct compat_efi_variable *src)
 {
@@ -263,7 +255,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	u8 *data;
 	int err;
 
-	if (is_compat()) {
+	if (in_compat_syscall()) {
 		struct compat_efi_variable *compat;
 
 		if (count != sizeof(*compat))
@@ -324,7 +316,7 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
 			     &entry->var.DataSize, entry->var.Data))
 		return -EIO;
 
-	if (is_compat()) {
+	if (in_compat_syscall()) {
 		compat = (struct compat_efi_variable *)buf;
 
 		size = sizeof(*compat);
@@ -418,7 +410,7 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	struct compat_efi_variable *compat = (struct compat_efi_variable *)buf;
 	struct efi_variable *new_var = (struct efi_variable *)buf;
 	struct efivar_entry *new_entry;
-	bool need_compat = is_compat();
+	bool need_compat = in_compat_syscall();
 	efi_char16_t *name;
 	unsigned long size;
 	u32 attributes;
@@ -495,7 +487,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (is_compat()) {
+	if (in_compat_syscall()) {
 		if (count != sizeof(*compat))
 			return -EINVAL;
 
diff --git a/kernel/time/time.c b/kernel/time/time.c
index ccdb351277ee..4638e8cb6378 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -863,7 +863,7 @@ int get_timespec64(struct timespec64 *ts,
 	ts->tv_sec = kts.tv_sec;
 
 	/* Zero out the padding for 32 bit systems or in compat mode */
-	if (IS_ENABLED(CONFIG_64BIT_TIME) && (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall()))
+	if (IS_ENABLED(CONFIG_64BIT_TIME) && in_compat_syscall())
 		kts.tv_nsec &= 0xFFFFFFFFUL;
 
 	ts->tv_nsec = kts.tv_nsec;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b669262682c9..dc4a9f1fb941 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2077,10 +2077,8 @@ int xfrm_user_policy(struct sock *sk, int optname, u8 __user *optval, int optlen
 	struct xfrm_mgr *km;
 	struct xfrm_policy *pol = NULL;
 
-#ifdef CONFIG_COMPAT
 	if (in_compat_syscall())
 		return -EOPNOTSUPP;
-#endif
 
 	if (!optval && !optlen) {
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_IN, NULL);
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index df7ca2dabc48..c3aedf8a99ff 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2621,10 +2621,8 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	const struct xfrm_link *link;
 	int type, err;
 
-#ifdef CONFIG_COMPAT
 	if (in_compat_syscall())
 		return -EOPNOTSUPP;
-#endif
 
 	type = nlh->nlmsg_type;
 	if (type > XFRM_MSG_MAX)
-- 
2.13.6
