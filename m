From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH 0/4] x86/efi: Minor cleanup patches
Date: Tue, 9 Sep 2014 09:03:31 +0200
Message-ID: <CA+rthh8RWz1OhspgqrnX1uYq-Sc=WARx16AgxWBOoZrAD6-D_A@mail.gmail.com>
References: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
	<20140908194105.GA18582@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140908194105.GA18582-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 8 September 2014 21:41, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Sun, 07 Sep, at 07:42:13PM, Mathias Krause wrote:
>> Hi Matt,
>>
>> this series is a collection of rather random cleanup patches. The init code
>> patch, though, should result in a lower runtime memory usage as more memory
>> can be released after initialization, now.
>>
>> Please apply!
>
> Thanks Mathias, these look good. Applied!
>
> Since they don't apply to the 'next' branch (queue for v3.18) and since
> they're cleanups with minimal risk, I've applied them to the 'urgent'
> branch.

Sorry, I should have checked that! I can send a rebased version if you
want me to.

Mathias
