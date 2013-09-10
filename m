From: David Lang <david-gFPdbfVZQbY@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Tue, 10 Sep 2013 12:17:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309101217150.10412@nftneq.ynat.uz>
References: <1378767723.17982.27.camel@x230.lan> <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz> <1378774394.17982.36.camel@x230.lan> <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz> <1378781715.17982.42.camel@x230.lan> <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
 <1378785208.17982.54.camel@x230.lan> <20130910172318.GB21530@khazad-dum.debian.net> <1378837571.17615.0.camel@x230.lan> <522F6519.4030004@zytor.com> <20130910185149.GC5559@kroah.com> <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, "Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org" <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 10 Sep 2013, Kees Cook wrote:

> Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
> 
> On Tue, Sep 10, 2013 at 11:51 AM, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>> On Tue, Sep 10, 2013 at 11:29:45AM -0700, H. Peter Anvin wrote:
>>> On 09/10/2013 11:26 AM, Matthew Garrett wrote:
>>>> On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
>>>>> On Tue, 10 Sep 2013, Matthew Garrett wrote:
>>>>>> That's why modern systems require signed firmware updates.
>>>>>
>>>>> Linux doesn't.  Is someone working on adding signature support to the
>>>>> runtime firmware loader?
>>>>
>>>> It'd be simple to do so, but so far the model appears to be that devices
>>>> that expect signed firmware enforce that themselves.
>>>>
>>>
>>> Most devices do absolutely no verification on the firmware, and simply
>>> trust the driver.
>>>
>>> So signing firmware is probably critical.
>>
>> How are you going to "validate" that the firmware is correct, given
>> that it's just a "blob" living in the linux-firmware tree.  If you sign
>> it, what is that saying?
>
> In theory these blobs are traceable to a manufacturer. It's not really
> an indication that it's "safe" more than it's an indication that it
> hasn't been changed. But I haven't chased this very hard yet because
> of below...

well, not if you are trying to defend against root breaking in to the machine.

David Lang
