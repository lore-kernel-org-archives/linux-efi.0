From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2 5/7] efi/capsule: Prepare for loading images with
 security header
Date: Tue, 28 Mar 2017 17:43:28 +0200
Message-ID: <8d26028c-0c1f-82be-a8b1-588ab7222ccd@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
 <47e87c8eccc0ee5c4033ece037c0bffc32782876.1490376860.git.jan.kiszka@siemens.com>
 <CAKv+Gu_+SVNr-g+BR1dGsSn_QGY9fA-TepQ2k6rHmW74VanPFQ@mail.gmail.com>
 <a3d4da19-015d-0559-f837-550631f1d491@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a3d4da19-015d-0559-f837-550631f1d491@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Hock Leong Kweh <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>, Sascha Weisenberger <sascha.weisenberger@siemens.com>
List-Id: linux-efi@vger.kernel.org

On 2017-03-28 17:13, Jan Kiszka wrote:
> On 2017-03-28 15:49, Ard Biesheuvel wrote:
>> On 24 March 2017 at 17:34, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>>> The Quark security header is nicely located in front of the capsule
>>> image, but we still need to pass the image to the update service as if
>>> there was none. Prepare efi_capsule_update and its user for this by
>>> defining and evaluating a EFI header displacement in the image located
>>> in memory. For standard-conforming capsules, this displacement is 0.
>>>
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> Hello Jan,
>>
>> Thanks for taking the time to respin this.
>>
>> I played around with these patches a bit (I can't really test them
>> since I don't have the hardware), and I am not really happy with the
>> non-trivial changes to the generic code, only to allow a header
>> displacement.
>>
>> So instead, I attempted to come up with an alternative which does not
>> use a displacement field, but makes the core capsule routines work
>> with a copy of the capsule header rather than mandating that it exists
>> at the start of the buffer. This way, we can override the code that
>> performs the copy, and make it originate from somewhere else.
>>
>> Could you please have a look at
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=quark-capsule
>>
>> and tell me if that would work for you? I will send them out for
>> proper review in any case, but to avoid confusion (if I missed
>> something obvious), I don't want to send them out just yet.
> 
> There is more needed to make things work again, maybe around passing the
> right image size. I'm looking into this.
> 

This makes CSH images being accepted again:

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 4b6f93f..a4e2311 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -562,6 +562,8 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 {
 	struct quark_security_header *csh = kbuff;
 
+	cap_info->total_size = 0;
+
 	if (!x86_match_cpu(quark_ids))
 		goto fallback;
 
@@ -587,12 +589,16 @@ int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 
 	kbuff += csh->headersize;
 
+	cap_info->total_size = csh->headersize;
+
 fallback:
 	if (hdr_bytes < sizeof(efi_capsule_header_t))
 		return 0;
 
 	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
 
+	cap_info->total_size += cap_info->header.imagesize;
+
 	return __efi_capsule_setup_info(cap_info);
 }
 
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index e851951..40dc354 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -42,7 +42,7 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 	int ret;
 	void *temp_page;
 
-	pages_needed = ALIGN(cap_info->header.imagesize, PAGE_SIZE) / PAGE_SIZE;
+	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) / PAGE_SIZE;
 
 	if (pages_needed == 0) {
 		pr_err("invalid capsule size");
@@ -59,7 +59,6 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 		return ret;
 	}
 
-	cap_info->total_size = cap_info->header.imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
@@ -87,6 +86,8 @@ int __weak efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
 
 	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
 
+	cap_info->total_size = cap_info->header.imagesize;
+
 	return __efi_capsule_setup_info(cap_info);
 }
 
But then my changes to efi_capsule_update are missing the present the
right format to the loader. As efi_capsule_update needs to lay out the
sg-list in as special way, excluding the CSH on the first page, it needs
to know about the displacement.

Any suggestions how to address that without rolling back to my aproach?

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
