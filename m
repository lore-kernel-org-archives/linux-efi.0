From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 04/18] pstore: Improve register_pstore() error reporting
Date: Mon,  6 Mar 2017 13:55:18 -0800
Message-ID: <1488837332-71582-5-git-send-email-keescook@chromium.org>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1488837332-71582-1-git-send-email-keescook@chromium.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Paul Mackerras <paulus@samba.org>, Anton Vorontsov <anton@enomsg.org>, linux-acpi@vger.kernel.org, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Len Brown <lenb@kernel.org>, Kees Cook <keescook@chromium.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw@hitachi.com>, Geliang Tang <geliangtang@163.com>, Tony Luck <tony.luck@intel.com>, Daniel Axtens <dja@axtens.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Colin Cross <ccross@android.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org

Uncommon errors are better to get reported to dmesg so developers can
more easily figure out why pstore is unhappy with a backend attempting
to register.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index d69ef8a840b9..320a673ecb5b 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -673,11 +673,15 @@ int pstore_register(struct pstore_info *psi)
 {
 	struct module *owner = psi->owner;
 
-	if (backend && strcmp(backend, psi->name))
+	if (backend && strcmp(backend, psi->name)) {
+		pr_warn("ignoring unexpected backend '%s'\n", psi->name);
 		return -EPERM;
+	}
 
 	spin_lock(&pstore_lock);
 	if (psinfo) {
+		pr_warn("backend '%s' already loaded: ignoring '%s'\n",
+			psinfo->name, psi->name);
 		spin_unlock(&pstore_lock);
 		return -EBUSY;
 	}
-- 
2.7.4
