From: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 02 Nov 2012 16:19:39 -0600
Message-ID: <509446FB.5000504@genband.com>
References: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>	<20121101210634.GA19723@srcf.ucam.org>	<20121101213127.5967327f@pyramind.ukuu.org.uk>	<20121101212843.GA20309@srcf.ucam.org>	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>	<20121101213452.GA20564@srcf.ucam.org>	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>	<20121101215752.GA21154@srcf.ucam.org> <87625ogzje.fsf@xmission.com>	<20121102140057.GA4668@srcf.ucam.org> <87liejacix.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87liejacix.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/02/2012 04:03 PM, Eric W. Biederman wrote:
> Matthew Garrett<mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>  writes:
>
>> On Fri, Nov 02, 2012 at 01:49:25AM -0700, Eric W. Biederman wrote:
>>
>>> When the goal is to secure Linux I don't see how any of this helps.
>>> Windows 8 compromises are already available so if we turn most of these
>>> arguments around I am certain clever attackers can go through windows to
>>> run compromised kernel on a linux system, at least as easily as the
>>> reverse.
>>
>> And if any of them are used to attack Linux, we'd expect those versions
>> of Windows to be blacklisted.
>
> I fail to see the logic here.  It is ok to trust Microsofts signing key
> because after I have been p0wned they will blacklist the version of
> windows that has was used to compromise my system?
>
> A key revokation will help me when my system is p0wned how?

It won't help you, it will help everyone else that _hasn't_ been p0wned 
already because the affected software will no longer be able to run on 
their system.

And it will help you because if someone _else_ gets p0wned then your 
system won't be able to run the blacklisted insecure software.

> I don't want my system p0wned in the first place and I don't want to run
> windows.  Why should I trust Microsoft's signing key?

In any case, you don't need to trust Microsoft's signing key...at least 
on x86 hardware you can install your own.  But if you want consumer 
hardware to be able to boot linux out-of-the-box without messing with 
BIOS settings then we need a bootloader that has been signed by Microsoft.

Chris
