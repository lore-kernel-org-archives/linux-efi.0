From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 00/18] pstore: refactor internal APIs
Date: Mon,  6 Mar 2017 13:55:14 -0800
Message-ID: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
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

For a long time I've been bothered by the complexity of argument passing
in the pstore internals, which makes understanding things and changing
things extremely fragile.

With the proposal of a new backend (EPI capsules), and my attempts to
reorganize things for the proposed multiple-pmsg frontend, I've spent
some time refactoring the internal pstore API to pass a record structure
instead of lots of arguments. This hugely simplifies things, and lets me
document the API better, reduce memory copies, etc.

Included in the series are a few bug fixes as well.

If pstore backend authors could review the changes I've made in their
drivers, I'd appreciate it. Hopefully I got it all right. :) And unless
there are any objections, I'll put this into -next in a couple days.

I intend to continue working on this to fix up the "ecc_notification_size"
field and make it more generalized, and get multiple pmsg support added
too, but I'd like to get this first series out for review first, since
it's rather long already.

Thanks!

-Kees
