From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/30] kexec_file: Restrict at runtime if the kernel is locked down
Date: Wed, 17 Jan 2018 16:16:56 +0000
Message-ID: <24245.1516205816@warthog.procyon.org.uk>
References: <20180111154445.duootisvanetnr24@dwarf.suse.cz> <12880.1515674600@warthog.procyon.org.uk> <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk> <13005.1515674877@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111154445.duootisvanetnr24-Q+Z4OdfSLAKN3ZZ/Hiejyg@public.gmane.org>
Content-ID: <24244.1516205816.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org> wrote:

> > Having said that, I do see your point, I think.  We should still let through
> > validly signed images, even if signatures aren't mandatory in lockdown mode.
> 
> yes, to be clear, the problem I'm trying to fix is:
> - without CONFIG_KEXEC_VERIFY_SIG kexec in a locked down kernel
>   will not work at all -> every distro that wants to support
>   secureboot will need to enable CONFIG_KEXEC_VERIFY_SIG;
> 
> - once CONFIG_KEXEC_VERIFY_SIG is enabled, kexec images need to
>   be signed even if secureboot is not used
>
> The problem is that CONFIG_KEXEC_VERIFY_SIG enables both the
> implementation and the enforcement of the signature checking.

Yep.  I understand that.

> What I'm proposing are new config options that allow a kernel to
> be compiled in such a way that:
> - kexec works even without signatures if secureboot is off
> - kexec works with secureboot but requires signed images

Agreed to both of those.  I also agree with making it possible to
configurationally require signatures, which your first patch does.

> The semantics should be the same as with signed modules, because
> requiring kexec signatures when you can load unsigned modules is
> futile. But with your original patchset, that's exactly what
> distro kernels will be doing when booted with secureboot off,
> MODULE_SIG_FORCE=n and KEXEC_VERIFY_SIG=y.

I should fix that.

David
