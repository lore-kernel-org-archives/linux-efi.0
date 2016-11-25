From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] efi: Get the secure boot status [ver #3]
Date: Fri, 25 Nov 2016 15:59:11 +0000
Message-ID: <5143.1480089551@warthog.procyon.org.uk>
References: <CAKv+Gu9qkPrq1rXN_7=BbZ=8v14Px+oHBqST0OnarUWVwhtZyg@mail.gmail.com> <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk> <147990565051.7576.9673287945782426886.stgit@warthog.procyon.org.uk> <1480016487.2444.18.camel@HansenPartnership.com> <15173.1480066220@warthog.procyon.org.uk> <CAKv+Gu_JxNLDjaK5jGbX9ACzM0uHJYMOFx7XDo4t7DtBMtFRGA@mail.gmail.com> <16661.1480075392@warthog.procyon.org.uk> <CAKv+Gu_d5+Kvo7Tptnpg7kfjpqxhQ3a3nsQ0Ufsm6rBOFry+mQ@mail.gmail.com> <17565.1480077303@warthog.procyon.org.uk> <CAKv+Gu9c-C2uXZ0fVatCM8ffXJZDgjBcDb_T0nsFecGqgrF11Q@mail.gmail.com> <31374.1480078855@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9qkPrq1rXN_7=BbZ=8v14Px+oHBqST0OnarUWVwhtZyg@mail.gmail.com>
Content-ID: <5142.1480089551.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: dhowells@redhat.com, James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> > +               if (val != 1)
> > +                       return 0;
> 
> val == 0 is better imo, since that will prevent unexpected values from
> being interpreted as 'secure boot disabled'

I've made that change.

David
