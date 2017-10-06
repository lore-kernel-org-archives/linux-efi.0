From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: Draft manpage explaining kernel lockdown
Date: Fri, 6 Oct 2017 15:46:49 +0800
Message-ID: <20171006074649.GB3789@linux-l9pv.suse>
References: <7969.1507201224@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7969.1507201224-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi David,

On Thu, Oct 05, 2017 at 12:00:24PM +0100, David Howells wrote:
> Hi Ard, Michael,
> 
> Attached is a draft for a manual page (kernel_lockdown.7) that I intend to
> point at from messages emitted when the kernel prohibits something because the
> kernel is in 'lockdown' mode, typically triggered by EFI secure boot.
> 
> Let me know what you think.
> 
> David
> ---
[...snip]
> When lockdown is in effect, a number of things are disabled or restricted in
> use.  This includes special device files and kernel services that allow direct
> access of the kernel image:
> .P
> .RS
> /dev/mem
> .br
> /dev/kmem
> .br
> /dev/kcore
> .br
> /dev/ioports
> .br
> BPF memory access functions

Some information for note...

The BPF functions bpf_probe_read(), bpf_trace_printk() and
bpf_probe_write_user() need to be lockdown to avoid accessing
arbitrary addess.

Our original idea is trying to filter out senstivie data address
at runtime by eBPF verifier. But it can not be success. Gary Lin has
investigated and comment:

  Although eBPF verifier can stop the reading from the hard-coded address, 
  it's not able to stop reading arguments in the probed functions. So if 
  the malicious user attaches a eBPF program to a function that is used to 
  process the sensitive data, the eBPF program can print those arguments 
  easily and this might leak the passwords or private keys.

If we readlly want to allow eBPF code to access memory, then I think that the
bpf bytecode should be signed by trused key in system keyring.

> .RE
> .P

Another function may needs to be restrictred:

- The perf_event_open() with PERF_SAMPLE_REGS_INTR

  Jann Horn raised this concern. The tool can be used to grab register
  to peep sensitive data. We may need to block this tracing function.

Regards
Joey Lee
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
