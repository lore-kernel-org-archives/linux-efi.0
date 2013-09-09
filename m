From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 9 Sep 2013 15:58:16 -0400
Message-ID: <CA+5PVA70Lw2f_4K6ys_xTyodo2VBWD+cOvTYHxWmqyQEX8784A@mail.gmail.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<27562.1378753264@turing-police.cc.vt.edu>
	<522E2487.90109@zytor.com>
	<CA+5PVA4mu=ykBMgWYaEagCsDexR-qFYH0tfjK+4B+xOCPonNXg@mail.gmail.com>
	<522E27DF.8020409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <522E27DF.8020409@zytor.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, David Lang <david@lang.hm>, Matthew Garrett <matthew.garrett@nebula.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 9, 2013 at 3:56 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> I.e. capabilities ;)
>>
>> Circles.  All I see here are circles.
>>
>> Having lived an entire release with a capabilities based mechanism for
>> this in Fedora, please no.
>>
>> And if you are talking about non-POSIX capabilities as you mentioned
>> earlier, that seems to be no different than having securelevel being a
>> bitmask of, well, levels.  I don't have much opinion on securelevel
>> being a big hammer or a bitmask of finer grained things, but I do
>> think it's a more manageable way forward.  Calling the implementation
>> "capabilities" seems to just be unnecessarily confusing.
>>
>
> This is the term "capability" in the general sense, not the POSIX
> implementation thereof.

See the whole last paragraph.  Particularly the last sentence.

josh
