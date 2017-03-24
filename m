From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 09:52:09 +0000
Message-ID: <CAKv+Gu-7z-JMK=sS2TLirAcyvvyU5w3ry4A8v-jreLsq_haN6A@mail.gmail.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com> <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com> <20170324092433.GA3237@gmail.com>
 <CAKv+Gu_V_VAWuDtKyOY9RS+cdhi+c5z2a7n2kcXVybvvdmPYBw@mail.gmail.com>
 <20170324094034.2afxgg43wlezdka5@pd.tnic> <CAKv+Gu9cyMccPSjzr9XGT6Gkhq57is+i_VajsZMTbd9eOAMkwQ@mail.gmail.com>
 <20170324094656.r2nln4vbidj5jhqt@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170324094656.r2nln4vbidj5jhqt-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 09:46, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> On Fri, Mar 24, 2017 at 09:42:40AM +0000, Ard Biesheuvel wrote:
>> That is a different matter. If the regions are only mapped while
>> runtime services invocations are in progress (as we do on ARM), I am
>> not sure if it matters that much, given how rarely that occurs in
>> normal use.
>
> Question is, is there anything worth protecting with ASLR or we don't
> care? I wanna say, we should randomize just in case, especially as it
> shouldn't be that expensive to do.
>

Well, given that in many cases, these pages are mapped R+W+X, I would
say that there is a risk involved in having these data structures at
fixed offsets.

Since UEFI v2.6, we have a new firmware table that describes strict
permission attributes for these regions, so everything can be mapped
writable or executable but never both. (Sai wired up the support for
this for x86 in v4.10)

> Also, how does the whole EFI-in-the-kexec-ed-kernel work on ARM? Runtime
> services get mapped on-demand in the kexec-ed kernel too?
>

Yes. On ARM, we use an ordinary mm_struct and just do a switch_mm()
with preemption disabled. So there is no need to reserve kernel VA
ranges, all UEFI runtime mappings are in the user area.
