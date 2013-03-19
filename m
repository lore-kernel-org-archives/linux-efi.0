From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Date: Tue, 19 Mar 2013 23:17:56 +0000
Message-ID: <20130319231756.GA21071@srcf.ucam.org>
References: <20130319014850.GA28934@srcf.ucam.org>
 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
 <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
 <20130319172506.GA11969@srcf.ucam.org>
 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
 <20130319182810.GA13003@srcf.ucam.org>
 <1363718456.2377.71.camel@dabdike.int.hansenpartnership.com>
 <20130319185003.GA13301@srcf.ucam.org>
 <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363734031.2377.77.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 19, 2013 at 11:00:31PM +0000, James Bottomley wrote:
> On Tue, 2013-03-19 at 18:50 +0000, Matthew Garrett wrote:
> > Well, that somewhat complicates implementation - we'd be encrypting the 
> > entire contents of memory except for the key that we're using to encrypt 
> > memory. Keeping the public key away from userspace avoids having to care 
> > about that.
> 
> I don't quite understand what you're getting at: the principle of public
> key cryptography is that you can make the public key, well public.  You
> only need to guard the private key.

Ok, so let's just rephrase it as asymmetric cryptography. The aim is to 
ensure that there's never a situation where userspace can decrypt a 
hibernation file, modify it and reencrypt it. So, shim (or whatever) 
generates a keypair. The encryption key is passed to the kernel being 
booted. The decryption key is stashed in a variable in order to be 
passed to the resume kernel.

If the decryption key is available to userspace then the kernel needs to 
discard the encryption key during image write-out - otherwise the 
encryption key will be in the encrypted image. If the decryption key 
isn't available to userspace then this isn't a concern.

If the decryption key *is* available to userspace (as it would be in 
your case), there's a requirement to discard the encryption key during 
the hibernation process. This isn't impossible, but it does add a little 
to the complexity.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
