From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Wed, 08 Nov 2017 21:17:37 -0500
Message-ID: <1510193857.4484.95.camel@linux.vnet.ibm.com>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <14219.1509660259@warthog.procyon.org.uk>
         <1509660641.3416.24.camel@linux.vnet.ibm.com>
         <20171107230700.GJ22894@wotan.suse.de> <20171108061551.GD7859@linaro.org>
         <20171108194626.GQ22894@wotan.suse.de> <20171109014841.GF7859@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20171109014841.GF7859@linaro.org>
Sender: owner-linux-security-module@vger.kernel.org
To: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Blunck <jblunck@infradead.org>, Julia Lawall <julia.lawall@lip6.fr>, David Howells <dhowells@redhat.com>, Marcus Meissner <meissner@suse.de>, Gary Lin <GLin@suse.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi <linux-efi@vger.kernel.org>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

> > IMHO that should just fail then, ie, a "locked down" kernel should not want to
> > *pass* a firmware signature if such thing could not be done.
> > 
> > Its no different than trying to verify a signed module on a "locked down" for
> > which it has no signature.
> > 
> > But perhaps I'm not understanding the issue well, let me know.
> 
> My point is quite simple:
> my_deviceA_init() {
>         err = request_firmware(&fw, "deviceA"); <--- (a)
>         if (err)
>                 goto err_request;
> 
>         err = verify_firmware(fw);  <--- (b)
>         if (err)
>                 goto err_verify;
> 
>         load_fw_to_deviceA(fw);     <--- (c)
>         ...
> }
> 
> As legacy device drivers does not have (b), there is no chance to
> prevent loading a firmware at (c) for locked-down kernel.
> 
> If you allow me to bring in yet another function, say
> request_firmware_signable(), which should be used in place of (a)
> for all verification-aware drivers, that would be fine.

I really don't understand why you need a new function.  The
request_firmware() eventually calls kernel_read_file_from_path(),
which already calls the pre and post LSM hooks.

IMA-appraisal is already on these hooks verifying the requested
firmware's signature.  For systems with "lockdown" enabled, but
without IMA-appraisal enabled, define a small, builtin LSM that sits
on these LSM hooks and denies the unsigned firmware requests.

Mimi

> In this case, all the invocation of request_firmware() in legacy code
> could be forced to fail in locked-down kernel.
> 
> But I think that "signable" should be allowed to be combined with other
> features of request_firmware variants like _(no)wait or _direct.
> 
> -Takahiro AKASHI

