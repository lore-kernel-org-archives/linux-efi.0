From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 9 Sep 2013 16:20:53 -0700
Message-ID: <CAGXu5jJdMXP84TPP-=dtExFkpcGKPGLWnOu1-PZMokz5WhCLwQ@mail.gmail.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<1378767723.17982.27.camel@x230.lan>
	<alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1309091614010.2479-UEhY+ZBZOcqqLGM74eQ/YA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Lang <david-gFPdbfVZQbY@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org" <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 9, 2013 at 4:19 PM, David Lang <david-gFPdbfVZQbY@public.gmane.org> wrote:
> On Mon, 9 Sep 2013, Matthew Garrett wrote:
>
>> On Mon, 2013-09-09 at 11:25 -0700, David Lang wrote:
>>
>>> 1 lock down modules
>>> 2 lock down kexec
>>
>>
>> Having thought about this, the answer is no. It presents exactly the
>> same problem as capabilities do - the set can never be meaningfully
>> extended. If an application sets only the bits it knows about, and if a
>> new security-sensitive feature is added to the kernel, the feature will
>> be left enabled and the system will be insecure. Alternatively, if an
>> application sets all the bits regardless of whether it knows them or
>> not, it may enable a lockdown feature that it otherwise required.
>
>
> In this case you are no less secure than you were before the feature was
> added, you just can't take advantage of the new feature without updating
> userspace.
>
> That's a very common situation
>
>
>> The only way this is useful is if all the bits are semantically
>> equivalent, and in that case there's no point in having anything other
>> than a single bit. Users who want a more fine-grained interface should
>> use one of the existing mechanisms for doing so - leave the kernel open
>> and impose the security policy from userspace using either capabilities
>> or selinux.
>
>
> so if you only have a single bit, how do you deal with the case where that
> bit locks down something that's required? (your reason for not just setting
> all bits in the first approach)
>
> your arguments don't seem self consistent.
>
>
> why should there only be one way to lock down a system? there are lots of
> different use cases.
>
> If I'm building a kiosk PC (or voting machine), I want to disable a lot of
> things that I could not get away with disabling on a generic laptop. Are we
> going to have Securelevel, ReallySecurelevel, ReallyReallySecurelevel, etc?
> or can we accept that security is not binary and allow users to disable
> features in a more granualar way?
>
> And if SELinux can do the job, what is the reason for creating this new
> option?

Not everyone uses SELinux. :) Also, it's rarely controlled the things
we want to control here.

-Kees

-- 
Kees Cook
Chrome OS Security
