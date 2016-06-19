From: =?UTF-8?Q?M=c3=b4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: Re: BGRT warns again on my system
Date: Sun, 19 Jun 2016 16:57:17 +0200
Message-ID: <5766B2CD.6010401@moshe.nl>
References: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
 <20160528222531.GA10687@x> <574A6B5D.60200@moshe.nl>
 <20160602092438.GD2658@codeblueprint.co.uk> <57669AC0.7010905@moshe.nl>
 <20160619143840.GA18605@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160619143840.GA18605@x>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/19/2016 04:38 PM, Josh Triplett wrote:
> On Sun, Jun 19, 2016 at 03:14:40PM +0200, M=F4she van der Sterre wrot=
e:
>> On 06/02/2016 11:24 AM, Matt Fleming wrote:
>>
>>> If this does indeed fix Andy's immediate issue (and it looks like
>>> it would) I'm happy to apply this as an interim solution.
>> I have tested that this does indeed fix the warning for Andy's value=
 of
>> ->image_address, but off course I can't test this with the actual ha=
rdware
>> that Andy has. Do you want me to resend this with a commit message s=
o it can
>> be applied?
> With a commit message and a clearer pr_notice than "is bogus", yes. H=
ow
> about "image address not a valid physical memory address"?

The sub-par notice text crossed my mind when I originally mailed it, bu=
t=20
I forgot about it today. I like your suggestion so I'll use that one.
