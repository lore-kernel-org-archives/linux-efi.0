From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Wed, 08 Nov 2017 15:01:09 -0500
Message-ID: <1510171269.4484.26.camel@linux.vnet.ibm.com>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <14219.1509660259@warthog.procyon.org.uk>
         <1509660641.3416.24.camel@linux.vnet.ibm.com>
         <20171107230700.GJ22894@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107230700.GJ22894@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi <linux-efi@vger.kernel.org>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
List-Id: linux-efi@vger.kernel.org


> > Or reflect that IMA-appraisal, if enabled, will enforce firmware being
> > validly signed.
> 
> But FWICT lockdown is a built-in kernel thingy, unless lockdown implies IMA
> it would not be the place to refer to it.
> 
> It seems the documentation was proposed to help users if an error was caught.
> That error should cover only what is being addressed in code on the kernel.

Enabling "lockdown" needs to take into account IMA-appraisal to
prevent breaking systems with it enabled.

An IMA builtin "secure_boot" policy was already upstreamed (commit
503ceaef8e2e "ima: define a set of appraisal rules requiring file
signatures").  An additional patch, automatically enables the
"secure_boot" policy in "lockdown" mode.

Refer to this discussion and patch:
http://kernsec.org/pipermail/linux-security-module-archive/2017-October/003913.html
http://kernsec.org/pipermail/linux-security-module-archive/2017-October/003910.html

thanks,

Mimi
