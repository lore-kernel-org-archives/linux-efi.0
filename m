From: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 9 Sep 2013 16:13:56 -0400
Message-ID: <CA+5PVA44KDyQxtmfiyjO323kOOoFo2cbD2pj-GnF1B3fhdms=Q@mail.gmail.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<27562.1378753264@turing-police.cc.vt.edu>
	<522E2487.90109@zytor.com>
	<CA+5PVA4mu=ykBMgWYaEagCsDexR-qFYH0tfjK+4B+xOCPonNXg@mail.gmail.com>
	<alpine.DEB.2.02.1309091300420.2479@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1309091300420.2479-UEhY+ZBZOcqqLGM74eQ/YA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Lang <david-gFPdbfVZQbY@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Valdis Kletnieks <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 9, 2013 at 4:10 PM, David Lang <david-gFPdbfVZQbY@public.gmane.org> wrote:
> On Mon, 9 Sep 2013, Josh Boyer wrote:
>
>> On Mon, Sep 9, 2013 at 3:41 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> On 09/09/2013 12:01 PM, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org wrote:
>>>>
>>>> On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:
>>>>
>>>>> Given that we know that people want signed binaries without
>>>>> blocking kexec, you should have '1' just enforce module signing
>>>>> and '2' (or higher) implement a full lockdown including kexec.
>>>>
>>>>
>>>>> Or, eliminate the -1  permanently insecure option and make this a
>>>>> bitmask, if someone wants to enable every possible lockdown, have
>>>>> them set it to "all 1's", define the bits only as you need them.
>>>>
>>>>
>>>> This strikes me as much more workable than one big sledgehammer.
>>>>
>>>
>>> I.e. capabilities ;)
>>
>>
>> Circles.  All I see here are circles.
>
>
> the thing is that these are not circles. they are separate orthoginal things
> that you may or may not want to allow.
>
> If this was a simple set of circles, then this could be defined as a vector
> instead of bitmap, the further you go the more secure you are.

I didn't mean your recommendation of using a bitmask.  I understood
your proposal and I don't even disagree with it really.  I was
replying to something else.

josh
