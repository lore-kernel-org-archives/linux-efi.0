From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 9 Sep 2013 16:34:07 -0700
Message-ID: <CAGXu5jLYEPwvjF=RffK2eBv5=3Fd+t1qJj9zuNuGLajyJLMzXw@mail.gmail.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<1378767723.17982.27.camel@x230.lan>
	<alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	<CAGXu5jJdMXP84TPP-=dtExFkpcGKPGLWnOu1-PZMokz5WhCLwQ@mail.gmail.com>
	<1378769438.6973.43.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1378769438.6973.43.camel@dabdike.int.hansenpartnership.com>
Sender: linux-security-module-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: David Lang <david@lang.hm>, Matthew Garrett <matthew.garrett@nebula.com>, "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 9, 2013 at 4:30 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2013-09-09 at 16:20 -0700, Kees Cook wrote:
>> On Mon, Sep 9, 2013 at 4:19 PM, David Lang <david@lang.hm> wrote:
>> > And if SELinux can do the job, what is the reason for creating this new
>> > option?
>>
>> Not everyone uses SELinux. :) Also, it's rarely controlled the things
>> we want to control here.
>
> It comes on by default (or its equivalent: AppArmour) in almost every
> shipping distro.

Right, if "LSM" was meant here, yeah, I do use an LSM. But they, as a
class of security policy in the kernel, handle isolation of entirely
different things. The goal of "no way to mess with ring-0" isn't
really related to the goals of the LSM in general, or specific MACs in
particular.

-Kees

-- 
Kees Cook
Chrome OS Security
