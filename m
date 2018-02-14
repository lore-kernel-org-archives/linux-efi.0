From: Benjamin Drung <benjamin.drung@profitbricks.com>
Subject: Re: Read-protected UEFI variables
Date: Wed, 14 Feb 2018 20:05:57 +0100
Message-ID: <1518635157.4749.50.camel@profitbricks.com>
References: <1518612748.4749.29.camel@profitbricks.com>
         <CAKv+Gu_V7BCihPhZf=pKrkBZwFWeEoupamXvYSqdS+k93Gme=g@mail.gmail.com>
         <1518614486.4749.33.camel@profitbricks.com>
         <e04b687f-30cd-c200-d08f-36b7dcc582a6@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e04b687f-30cd-c200-d08f-36b7dcc582a6@moshe.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?M=F4she?= van der Sterre <me@moshe.nl>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Am Mittwoch, den 14.02.2018, 19:18 +0100 schrieb Môshe van der Sterre:
> On 02/14/2018 02:21 PM, Benjamin Drung wrote:
> > If the UEFI is as secure as storing an unencrypted file on a hard
> > drive, I am satisfied. Or do you have a better idea where to store
> > the
> > SSH keys for a diskless system that boots via network?
> 
> I assume it would be best to use TPM for this (if your systems have
> TPM chips), it is designed for use-cases like this. Searching for
> "tpm ssh keys" gives a decent amount of results. Mostly targeted at
> user keys instead of server keys, so this might need some tinkering
> to get working.

I check our systems. They just have TPM headers, but no TPM chips
according to the user manual. The directory /sys/class/tpm/ is either
empty or not existing. Adding TPM chips to all servers is no too
expensive (to much man power required). So sadly, this is no option for
us.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung@profitbricks.com
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
