From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 0/3] Use mm_struct and switch_mm() instead of manually
Date: Mon, 29 Jan 2018 10:51:26 +0000
Message-ID: <CAKv+Gu-mrMpgFVssUH1RXP6GAKuPNtQwwsCNTqv2Oa48FrU+Bg@mail.gmail.com>
References: <1516309264-23926-1-git-send-email-sai.praneeth.prakhya@intel.com> <20180126211643.GB6520@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126211643.GB6520-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 January 2018 at 21:16, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 18 Jan, at 01:01:04PM, Sai Praneeth Prakhya wrote:
>> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Presently, in x86, to invoke any efi function like
>> efi_set_virtual_address_map() or any efi_runtime_service() the code path
>> typically involves read_cr3() (save previous pgd), write_cr3()
>> (write efi_pgd) and calling efi function. Likewise after returning from
>> efi function the code path typically involves read_cr3() (save efi_pgd),
>> write_cr3() (write previous pgd). We do this couple of times in efi
>> subsystem of Linux kernel, instead we can use helper function
>> efi_switch_mm() to do this. This improves readability and maintainability.
>> Also, instead of maintaining a separate struct "efi_scratch" to store/restore
>> efi_pgd, we can use mm_struct to do this.
>
> FWIW this series looks OK to me.
>
> Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

Thanks Matt

I know the x86 guys have been rather busy lately, so I will give them
some more time to respond. If there are no objections raised, I will
queue it for v4.17 in a couple of weeks.
