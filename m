From: Ye Xiaolong <xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/7] efi: Get the secure boot status [ver #7]
Date: Fri, 3 Feb 2017 10:48:46 +0800
Message-ID: <20170203024845.GE23647@yexl-desktop>
References: <148587562967.4026.18171897997650345605.stgit@warthog.procyon.org.uk>
 <201702010101.EljWXBuB%fengguang.wu@intel.com>
 <CAKv+Gu92yTWcEguxGzMOQAvoUexCLtsVVBa2Xzz3cPPWQD9nSQ@mail.gmail.com>
 <10308.1485888776@warthog.procyon.org.uk>
 <CAKv+Gu_oUcbQ9CYLTentjoHWreVX7Y2-SN5BBcxZ_g4-pNG1yw@mail.gmail.com>
 <20170201214806.GO31613@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170201214806.GO31613-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkp <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/02, Matt Fleming wrote:
>On Tue, 31 Jan, at 08:18:16PM, Ard Biesheuvel wrote:
>> On 31 January 2017 at 18:52, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> >
>> >> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
>> >>
>> >> This is the wrong repo ^^^
>> >>
>> >> I am not sure if there is anything we can do about this, but perhaps
>> >> you should simply remove it now that we've migrated to the new repo.
>> >
>> > Is the error a derivative of the rebase?  I'm sure this was working in the
>> > un-rebased code.
>> >
>>
>> Well, indirectly. The kbuild robot is applying the patches onto an
>> outdated EFI branch owned by Matt, rather than the official one which
>> has my patch that turns the runtime services struct from a collection
>> of pointers to void into properly typed function pointers.
>
>Fengguang, can you update the official EFI repository to now be,
>
>  https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git

Done, just send a patch to replace the outdated repo.

Thanks,
Xiaolong
>
>Thanks!
>
