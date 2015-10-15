From: "Croxon, Nigel" <nigel.croxon-ZPxbGqLxI0U@public.gmane.org>
Subject: CPER support for 32GiB 64GiB DIMMs
Date: Thu, 15 Oct 2015 17:59:08 +0000
Message-ID: <A4930445748CDC43B8495613130746F43CBE2BAF@G9W0735.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Croxon, Nigel" <nigel.croxon-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello all,

Description of problem: The existing Common Platform Error Record
(CPER) memory error format can't fully support 32GiB and 64GiB DIMMs.

The UEFI spec has changed to use previously reserved bits in the
record provide that support. Kernel processing of CPER memory error
records will need to change to reflect the new spec.

N.2.5 Memory Error Section
Bits <18:21> was set as 'reserved', and now is used as 'extended'.
http://www.uefi.org/sites/default/files/resources/2_4_Errata_A.pdf

Matt Fleming mentioned to me that Tony Luck recently fixed a 
compatibility issue with Memory Error Record structure.
I ask, how do we want to handle the processing of a CPER
memory error record with support for larger DIMMs?

-Nigel


From: Nigel Croxon <nigel.croxon-ZPxbGqLxI0U@public.gmane.org>
Date: Tue, 13 Oct 2015 15:21:19 -0400
Subject: [PATCH] CPER: support 32GiB 64GiB DIMMs

Description of problem: The existing Common Platform Error Record
(CPER) memory error format can't fully support 32GiB and 64GiB DIMMs.
The UEFI spec has changed to use previously reserved bits in the
record provide that support. Kernel processing of CPER memory error
records will need to change to reflect the new spec.

UEFI 2.4 Errata A - December, 2013
N.2.5 Memory Error Section
Bits <18:21> was set as 'reserved'. Now used as 'extended'.

Signed-off-by: Nigel Croxon <nigel.croxon-ZPxbGqLxI0U@public.gmane.org>
---
 include/linux/cper.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/cper.h b/include/linux/cper.h
index dcacb1a..4ece589 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -243,6 +243,10 @@ enum {
 #define CPER_MEM_VALID_RANK_NUMBER		0x8000
 #define CPER_MEM_VALID_CARD_HANDLE		0x10000
 #define CPER_MEM_VALID_MODULE_HANDLE		0x20000
+#define CPER_MEM_VALID_EXT_ROW_B16_17		0x40000
+#define CPER_MEM_VALID_BANK_GROUP		0x80000
+#define CPER_MEM_VALID_BANK_ADDRESS		0x100000
+#define CPER_MEM_VALID_CHIP_ID			0x200000
 
 #define CPER_PCIE_VALID_PORT_TYPE		0x0001
 #define CPER_PCIE_VALID_VERSION			0x0002
@@ -378,7 +382,7 @@ struct cper_sec_mem_err {
 	__u64	responder_id;
 	__u64	target_id;
 	__u8	error_type;
-	__u8	reserved;
+	__u8	extended;
 	__u16	rank;
 	__u16	mem_array_handle;	/* card handle in UEFI 2.4 */
 	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
-- 
1.7.1
