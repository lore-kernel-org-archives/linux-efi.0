From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/2] x86/mm/pat: Prevent hang during boot when mapping pages
Date: Tue, 20 Sep 2016 15:48:28 +0100
Message-ID: <20160920144829.30873-2-matt@codeblueprint.co.uk>
References: <20160920144829.30873-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920144829.30873-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Douglas Hatch <doug.hatch@hpe.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Scott J Norton <scott.norton@hpe.com>, Theodore Ts'o <tytso@mit.edu>, Waiman Long <waiman.long@hpe.com>
List-Id: linux-efi@vger.kernel.org

There's a mixture of signed 32-bit and unsigned 32-bit and 64-bit data
types used for keeping track of how many pages have been mapped.

This leads to hangs during boot when mapping large numbers of pages
(multiple terabytes, as reported by Waiman) because those values are
interpreted as being negative.

commit 742563777e8d ("x86/mm/pat: Avoid truncation when converting
cpa->numpages to address") fixed one of those bugs, but there is
another lurking in __change_page_attr_set_clr().

Additionally, the return value type for the populate_*() functions can
return negative values when a large number of pages have been mapped,
triggering the error paths even though no error occurred.

Consistently use 64-bit types on 64-bit platforms when counting pages.
Even in the signed case this gives us room for regions 8PiB
(pebibytes) in size whilst still allowing the usual negative value
error checking idiom.

Reported-by: Waiman Long <waiman.long@hpe.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Ts'o <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Scott J Norton <scott.norton@hpe.com>
Cc: Douglas Hatch <doug.hatch@hpe.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 849dc09fa4f0..e3353c97d086 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -917,11 +917,11 @@ static void populate_pte(struct cpa_data *cpa,
 	}
 }
 
-static int populate_pmd(struct cpa_data *cpa,
-			unsigned long start, unsigned long end,
-			unsigned num_pages, pud_t *pud, pgprot_t pgprot)
+static long populate_pmd(struct cpa_data *cpa,
+			 unsigned long start, unsigned long end,
+			 unsigned num_pages, pud_t *pud, pgprot_t pgprot)
 {
-	unsigned int cur_pages = 0;
+	long cur_pages = 0;
 	pmd_t *pmd;
 	pgprot_t pmd_pgprot;
 
@@ -991,12 +991,12 @@ static int populate_pmd(struct cpa_data *cpa,
 	return num_pages;
 }
 
-static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
-			pgprot_t pgprot)
+static long populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
+			 pgprot_t pgprot)
 {
 	pud_t *pud;
 	unsigned long end;
-	int cur_pages = 0;
+	long cur_pages = 0;
 	pgprot_t pud_pgprot;
 
 	end = start + (cpa->numpages << PAGE_SHIFT);
@@ -1052,7 +1052,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 
 	/* Map trailing leftover */
 	if (start < end) {
-		int tmp;
+		long tmp;
 
 		pud = pud_offset(pgd, start);
 		if (pud_none(*pud))
@@ -1078,7 +1078,7 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
 	pud_t *pud = NULL;	/* shut up gcc */
 	pgd_t *pgd_entry;
-	int ret;
+	long ret;
 
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
@@ -1327,7 +1327,8 @@ static int cpa_process_alias(struct cpa_data *cpa)
 
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 {
-	int ret, numpages = cpa->numpages;
+	unsigned long numpages = cpa->numpages;
+	int ret;
 
 	while (numpages) {
 		/*
-- 
2.9.3
