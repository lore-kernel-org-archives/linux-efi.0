From: HATAYAMA Daisuke <d.hatayama-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Date: Fri, 22 Nov 2013 12:32:30 +0900
Message-ID: <528ED04E.4060606@jp.fujitsu.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com> <20131121230744.GA31592@srcf.ucam.org> <528E94D1.2050809@zytor.com> <20131121233705.GA32121@srcf.ucam.org> <528EAF99.1010503@zytor.com> <20131122012524.GA5627@anatevka.fc.hp.com> <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com> <20131122022957.GE31921@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131122022957.GE31921-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jerry.hoemann-VXdhtT5mjnY@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo.kernel.org-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Atsushi Kumagai <kumagai-atsushi-biTfD1RFvDe45+QrQBaojngSJqDPrsil@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(2013/11/22 11:29), Vivek Goyal wrote:
> [..]
>>> makedumpfile going to cyclic buffer has helped out greatly, but on
>>> our new systems we're still looking at 512 MB crash kernels.
>>
>> I tried 6TiB system/16 PCIE cards, kdump on RHEL 6.5 beta still does not work.
>> still get OOM.
>
> What crashkernel= option you are using?
>
> Interesting. So something is consuming lot of memory. How about setting
> "debug_mem_level 1" in /etc/kdump.conf and regenerate initrd and retry.
> This time it should output some memory usage info at various points
> during boot and that can give us some idea who is consuming how much
> memory.
>
> If some module are consuming lot of memory, then you can try "blacklist"
> option in /etc/kdump.conf to disable those.
>
> If it is not modules, then it will concern me because then either
> kernel is consuming too much memory (which it should not) or for
> some reason makedumpfile cyclic mode did not work for you properly.
>
> While you are re-testing, how about also increasing debug message
> level of makedumpfile. makedumpfile developers should be able to
> have a look at that. In /etc/kdump.conf, specify.
>
> core_collector makedumpfile -c --message-level 31 -d 31
>
> If message level 31 turns out to be too verbose, reduce it as per
> makedumpfile man page.
>

The following configuration is more flexible:

core_collector false
default shell

Then crash dump collection fails and emergency shell shows up,
where you can type a variety of commands.

If 2nd kernel keeps failing even on this configuration, it's likely
that kernel side already causes the OOM you're facing before reaching
invocation of the command specified by core_collector directive.

-- 
Thanks.
HATAYAMA, Daisuke
