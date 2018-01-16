From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08a/30] kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE
Date: Tue, 16 Jan 2018 16:31:51 +0000
Message-ID: <4582.1516120311@warthog.procyon.org.uk>
References: <20180111120157.23qceywzi6omvvkb@dwarf.suse.cz> <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk> <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk> <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111120157.23qceywzi6omvvkb-Q+Z4OdfSLAKN3ZZ/Hiejyg@public.gmane.org>
Content-ID: <4581.1516120311.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I think that your code isn't quite right.  Looking at the patched code:

    #ifdef CONFIG_KEXEC_SIG
	sig_err = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
					   image->kernel_buf_len);
	if (sig_err)
		pr_debug("kernel signature verification failed.\n");
	else
		pr_debug("kernel signature verification successful.\n");
    #endif

	if (sig_err && IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
		ret = sig_err;
		goto out;
	}

If the signature check fails because the signature is bad, but
CONFIG_KEXEC_SIG_FORCE=n then it now won't fail when it should.

If sig_err is -EKEYREJECTED, -EKEYEXPIRED or -EKEYREVOKED then it must fail,
even if the signature check isn't forced.

David
