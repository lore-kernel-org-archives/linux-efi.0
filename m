From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:37:28 +0000
Message-ID: <20121031173728.GA18615@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <s5hobjia6vj.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <s5hobjia6vj.wl%tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 06:28:16PM +0100, Takashi Iwai wrote:

> request_firmware() is used for microcode loading, too, so it's fairly
> a core part to cover, I'm afraid.
> 
> I played a bit about this yesterday.  The patch below is a proof of
> concept to (ab)use the module signing mechanism for firmware loading
> too.  Sign firmware files via scripts/sign-file, and put to
> /lib/firmware/signed directory.

That does still leave me a little uneasy as far as the microcode 
licenses go. I don't know that we can distribute signed copies of some 
of them, and we obviously can't sign at the user end.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
