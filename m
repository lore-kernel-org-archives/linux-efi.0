From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Fri, 24 Mar 2017 16:18:20 +0100
Message-ID: <716974af-d63d-ffe7-3846-a3f8c98f9d7c@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <b95b71b7-6b5f-f9cc-79e4-3600e9a3f7e5@siemens.com>
 <CAKv+Gu_2edBA++6ywE4FE2NSbkCWjEULPmriS1iBifsRCgA+OA@mail.gmail.com>
 <3641f43d-ecfd-03dd-9e5d-ca32d587d318@siemens.com>
 <c1beeeb5-2359-d9c1-4759-b112c7d1a613@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c1beeeb5-2359-d9c1-4759-b112c7d1a613@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Sascha Weisenberger <sascha.weisenberger@siemens.com>, Daniel Wagner <daniel.wagner@siemens.com>
List-Id: linux-efi@vger.kernel.org

On 2017-02-20 02:33, Bryan O'Donoghue wrote:
> 
> 
> On 19/02/17 13:33, Jan Kiszka wrote:
>>> I would not object strongly to having conditionally compiled code in
>>> mainline that adds support for this, but bodging the default code path
>>> like this for a Quark quirk is out of the question imo.
>> I'm open for any consensus that avoids bending mainline too much and
>> still helps us (and maybe also other Quark X1020 integrators) getting
>> rid of additional patches.
> 
> We could make efi_capsule_setup_info() a weak symbol just like
> 
> drivers/firmware/efi/reboot.c:
> bool __weak efi_poweroff_required(void)
> 
> that way Arm is none the wiser and we can bury the Quark Quirk in
> x86/platform/efi/quirks.c - where you're right Ard it arguably belongs -
> not in the core code.
> 
> diff --git a/arch/x86/platform/efi/quirks.c
> b/arch/x86/platform/efi/quirks.c
> index 30031d5..950663da 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -495,3 +495,19 @@ bool efi_poweroff_required(void)
>  {
>         return acpi_gbl_reduced_hardware || acpi_no_s5;
>  }
> +
> +ssize_t csh_efi_capsule_setup_info(struct capsule_info *cap_info,
> +                                  void *kbuff, size_t hdr_bytes)
> +{
> +       /* Code to deal with the CSH goes here */
> +       return 0;
> +}
> +
> +ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
> +                              void *kbuff, size_t hdr_bytes)
> +{
> +       if (quark)
> +               return csh_efi_capsule_setup_info(cap_info, kbuff,
> hdr_bytes);
> +       else
> +               return __efi_capsule_setup_info(cap_info, kbuff,
> hdr_bytes);
> +}
> 
> diff --git a/drivers/firmware/efi/capsule-loader.c
> b/drivers/firmware/efi/capsule-loader.c
> index 9ae6c11..d8bdc6f 100644
> --- a/drivers/firmware/efi/capsule-loader.c
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -53,7 +53,7 @@ static void efi_free_all_buff_pages(struct
> capsule_info *cap_info)
>   * @kbuff: a mapped first page buffer pointer
>   * @hdr_bytes: the total received number of bytes for efi header
>   **/
> -static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
> +ssize_t __efi_capsule_setup_info(struct capsule_info *cap_info,
>                                       void *kbuff, size_t hdr_bytes)
>  {
>         efi_capsule_header_t *cap_hdr;
> @@ -98,6 +98,13 @@ static ssize_t efi_capsule_setup_info(struct
> capsule_info *cap_info,
> 
>         return 0;
>  }
> +EXPORT_SYMBOL_GPL(__efi_capsule_setup_info);
> +
> +ssize_t __weak efi_capsule_setup_info(struct capsule_info *cap_info,
> +                                            void *kbuff, size_t hdr_bytes)
> +{
> +       return __efi_capsule_setup_info(cap_info, kbuff, hdr_bytes);
> +}
> 
> One thing we want is to continue to have Quark work on ia32 builds
> without having to compile a Quark specific kernel just to get this
> feature working.

Done now in my newer patches. Some refactoring in the core is still
required, but the Quark logic will be active only on x86 and fully
executed only on Quark CPUs.

> 
> Jan I haven't had time to look at what you said about the BSP code not
> working with capsules on Gen2 (I will during the week though). If you
> currently have to strip the CSH to make this work then we're missing a
> trick on tip-of-tree and need to sort that out for the final version of
> this.

No idea what went wrong back then, but I was able to reflash a Gen2
multiple times these days with the original 1.1.0 and 1.0.4 capsules
Intel ships for that board - without removing the CSH. IOW, we can
finally use capsule support on the Galileo.

Patches to come soon.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
