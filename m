From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:08:20 +0000
Message-ID: <20121031170820.2b26802a@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
	<20121031155635.GA14294@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121031155635.GA14294-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012 15:56:35 +0000
Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:

> 1) Gain root.
> 2) Modify swap partition directly.
> 3) Force reboot.
> 4) Win.
> 
> Root should not have the ability to elevate themselves to running 
> arbitrary kernel code. Therefore, the above attack needs to be 
> impossible.

To protect swap you need to basically disallow any unencrypted swap (as
he OS can't prove any given swap device is local and inside the case) and
disallow the use of most disk management tools (so you'll need to write a
few new management interfaces or implement the BPF based command filters
that have been discussed for years).

In addition of course there is no requirement that a device returns
the data you put on it so subverted removable media is a potential issue.
Or indeed just cheap memory sticks that do it anyway ;)

Oh and of course the file systems in default mode don't guarantee this so
you'll need to fix ext3, ext4 8)
