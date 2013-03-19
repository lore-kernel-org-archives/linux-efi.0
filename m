From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Tue, 19 Mar 2013 23:00:31 +0000
Message-ID: <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
	 <20130319014850.GA28934@srcf.ucam.org>
	 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
	 <20130319163531.GA10879@srcf.ucam.org>
	 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
	 <20130319172506.GA11969@srcf.ucam.org>
	 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
	 <20130319182810.GA13003@srcf.ucam.org>
	 <1363718456.2377.71.camel@dabdike.int.hansenpartnership.com>
	 <20130319185003.GA13301@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130319185003.GA13301-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-03-19 at 18:50 +0000, Matthew Garrett wrote:
> On Tue, Mar 19, 2013 at 06:40:56PM +0000, James Bottomley wrote:
> > On Tue, 2013-03-19 at 18:28 +0000, Matthew Garrett wrote:
> > > It requires the key to survive the system being entirely powered down, 
> > > which means it needs to be BS+NV. It shouldn't be possible for userspace 
> > > to access this key.
> > 
> > It requires the *public* key to survive power down, certainly.  The
> > private key can be thrown away once the hibernate image is signed.  I
> > think the scheme can be constructed so the private key is never in NV
> > storage ... that also makes it more secure against tampering.
> 
> Well, that somewhat complicates implementation - we'd be encrypting the 
> entire contents of memory except for the key that we're using to encrypt 
> memory. Keeping the public key away from userspace avoids having to care 
> about that.

I don't quite understand what you're getting at: the principle of public
key cryptography is that you can make the public key, well public.  You
only need to guard the private key.

James
