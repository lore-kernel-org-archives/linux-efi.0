From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/6] arm64: ptdump: fold string literals into address_markers[] and pte_bits[]
Date: Fri, 22 Apr 2016 18:48:05 +0200
Message-ID: <1461343688-8552-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461343688-8552-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Replace the indirect string references in struct addr_marker and struct
prot_bits with char array fields. Under a relocatable kernel, this not
only saves 8 bytes in the absolute address that we no longer have to record,
it also saves 24 bytes of init data (the size of a RELA entry) since this
address no longer requires relocation processing at boot.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
I am aware that this is a drop in the ocean, but I thought I'd include it
anyway, since many people may not even realize that this issue exists in
the first place.
---
 arch/arm64/mm/dump.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index 8404190fe2bd..024f803e2fb4 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -30,7 +30,7 @@
 
 struct addr_marker {
 	unsigned long start_address;
-	const char *name;
+	char name[32];
 };
 
 static const struct addr_marker address_markers[] = {
@@ -51,7 +51,7 @@ static const struct addr_marker address_markers[] = {
 	{ VMEMMAP_START + VMEMMAP_SIZE,	"vmemmap end" },
 #endif
 	{ PAGE_OFFSET,			"Linear Mapping" },
-	{ -1,				NULL },
+	{ -1 },
 };
 
 /*
@@ -69,10 +69,10 @@ struct pg_state {
 };
 
 struct prot_bits {
-	u64		mask;
-	u64		val;
-	const char	*set;
-	const char	*clear;
+	u64	mask;
+	u64	val;
+	char	set[16];
+	char	clear[8];
 };
 
 static const struct prot_bits pte_bits[] = {
@@ -184,7 +184,7 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
 		else
 			s = bits->clear;
 
-		if (s)
+		if (*s)
 			seq_printf(st->seq, " %s", s);
 	}
 }
-- 
2.7.4
