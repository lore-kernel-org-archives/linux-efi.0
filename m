From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] x86/mm/pageattr: Avoid truncation when converting cpa->numpages to address
Date: Fri, 29 Jan 2016 11:36:10 +0000
Message-ID: <1454067370-10374-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?q?Viorel-C=C4=83t=C4=83lin=20R=C4=83pi=C8=9Beanu?= <rapiteanu.catalin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There are a couple of nasty truncation bugs lurking in the pageattr
code that can be triggered when mapping EFI regions, e.g. when we pass
a cpa->pgd pointer. Because cpa->numpages is a 32-bit value, shifting
left by PAGE_SHIFT will truncate the resultant address to 32-bits.

Viorel-C=C4=83t=C4=83lin managed to trigger this bug on his Dell machin=
e that
provides a ~5GB EFI region which requires 1236992 pages to be mapped.
When calling populate_pud() the end of the region gets calculated
incorrectly in the following buggy expression,

  end =3D start + (cpa->numpages << PAGE_SHIFT);

And only 188416 pages are mapped. Next, populate_pud() gets invoked
for a second time because of the loop in __change_page_attr_set_clr(),
only this time no pages get mapped because shifting the remaining
number of pages (1048576) by PAGE_SHIFT is zero. At which point the
loop in __change_page_attr_set_clr() spins forever because we fail to
map progress.

Hitting this bug depends very much on the virtual address we pick to
map the large region at and how many pages we map on the initial run
through the loop. This explains why this issue was only recently hit
with the introduction of commit

  a5caa209ba9c ("x86/efi: Fix boot crash by mapping EFI memmap entries =
bottom-up at runtime, instead of top-down")

It's interesting to note that safe uses of cpa->numpages do exist in
the pageattr code. If instead of shifting ->numpages we multiply by
PAGE_SIZE, no truncation occurs because PAGE_SIZE is a UL value, and
so the result is unsigned long.

To avoid surprises when users try to convert very large cpa->numpages
values to addresses, change the data type from 'int' to 'unsigned
long', thereby making it suitable for shifting by PAGE_SHIFT without
any type casting.

The alternative would be to make liberal use of casting, but that is
far more likely to cause problems in the future when someone adds more
code and fails to cast properly; this bug was difficult enough to
track down in the first place.

Reported-by: Viorel-C=C4=83t=C4=83lin R=C4=83pi=C8=9Beanu <rapiteanu.ca=
talin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Viorel-C=C4=83t=C4=83lin R=C4=83pi=C8=9Beanu <rapiteanu.cata=
lin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D110131
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/mm/pageattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index fc6a4c8f6e2a..2440814b0069 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -33,7 +33,7 @@ struct cpa_data {
 	pgd_t		*pgd;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
-	int		numpages;
+	unsigned long	numpages;
 	int		flags;
 	unsigned long	pfn;
 	unsigned	force_split : 1;
@@ -1350,7 +1350,7 @@ static int __change_page_attr_set_clr(struct cpa_=
data *cpa, int checkalias)
 		 * CPA operation. Either a large page has been
 		 * preserved or a single page update happened.
 		 */
-		BUG_ON(cpa->numpages > numpages);
+		BUG_ON(cpa->numpages > numpages || !cpa->numpages);
 		numpages -=3D cpa->numpages;
 		if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY))
 			cpa->curpage++;
--=20
2.6.2
