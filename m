From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Mon, 21 Aug 2017 17:08:50 +0100
Message-ID: <CAKv+Gu_whUkAdM4xHLs-Cm90hRmqBbVgyDTyBVrGoTO1G6WzLg@mail.gmail.com>
References: <20170816110321.GC17270@leverpostej> <20170816125715.GB3384@codeblueprint.co.uk>
 <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
 <20170815223541.GA25778@remoulade> <20170817103514.GC27872@arm.com>
 <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q@mail.gmail.com>
 <20170821103359.jt2xf2cx5wxjldau@hirez.programming.kicks-ass.net>
 <E5C753C8-1B92-4B4F-B95D-32DCC5C0AF5F@amacapital.net> <20170821140813.idloyrk4lowann3j@hirez.programming.kicks-ass.net>
 <6E0248C9-19AB-474E-A901-2A0422337DD0@amacapital.net> <20170821155913.7bmmy7zaihpd6s7h@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170821155913.7bmmy7zaihpd6s7h-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ravi V. Shankar" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 August 2017 at 16:59, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Aug 21, 2017 at 08:23:10AM -0700, Andy Lutomirski wrote:
>> > Ah, but only root can create per-cpu events or attach events to kernel
>> > threads (with sensible paranoia levels).
>>
>> But this may not need to be percpu.  If a non root user can trigger, say, an EFI variable read in their own thread context, boom.
>
> I was going by the proposed: "everything EFI in a kthread" model. But
> yes, if that's not done, then you're quite right.
>

How does this work in cases where we need to call into UEFI from
non-process context? Or at least from a context where current != EFI's
kthread. We have EFI pstore code, for instance, that records panic
data. Should we make an exception for those?

I'm happy to have a stab at implementing the EFI kthread, but I'd like
to get some of these details clarified first.
