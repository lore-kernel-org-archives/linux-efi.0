From: Jiri Bohac <jbohac@suse.cz>
Subject: Re: [PATCH 08a/30] kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG
 and KEXEC_SIG_FORCE
Date: Tue, 16 Jan 2018 20:39:36 +0100
Message-ID: <20180116193936.oiycvwlk5xy3gm77@dwarf.suse.cz>
References: <20180111120157.23qceywzi6omvvkb@dwarf.suse.cz>
 <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
 <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
 <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz>
 <4582.1516120311@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4582.1516120311@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Chun-Yi Lee <joeyli.kernel@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 16, 2018 at 04:31:51PM +0000, David Howells wrote:
> I think that your code isn't quite right.  Looking at the patched code:
> 
>     #ifdef CONFIG_KEXEC_SIG
> 	sig_err = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
> 					   image->kernel_buf_len);
> 	if (sig_err)
> 		pr_debug("kernel signature verification failed.\n");
> 	else
> 		pr_debug("kernel signature verification successful.\n");
>     #endif
> 
> 	if (sig_err && IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
> 		ret = sig_err;
> 		goto out;
> 	}
> 
> If the signature check fails because the signature is bad, but
> CONFIG_KEXEC_SIG_FORCE=n then it now won't fail when it should.
> 
> If sig_err is -EKEYREJECTED, -EKEYEXPIRED or -EKEYREVOKED then it must fail,
> even if the signature check isn't forced.

It wasn't my intention to fail in these cases. What additional
security does this bring? If simply stripping an invalid
signature from the image before loading will make it pass, why
should the image with an invalid signature be rejected?

Indeed, the module signing code, the semantics of which I wanted
to mimic, also won't load modules with invalid signatures. It
will load modules without any signatuire, it will load  modules
with the MODULE_SIG_STRING modified and it will load modules with
either of MODULE_INIT_IGNORE_MODVERSIONS or
MODULE_INIT_IGNORE_VERMAGIC passed as flags to the finit_module
syscall. In all these cases, it will taint the kernel, which
might be something we want for kexec_file_load as well (?).

But I don't see why it distinguishes between ENOKEY and other
errors when it's so easy for the caller to strip the invalid
signature. And why kexec_file_load should do the same.

What am I missing?

Thanks,

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

