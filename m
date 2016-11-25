From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] efi: Get the secure boot status [ver #3]
Date: Fri, 25 Nov 2016 12:35:03 +0000
Message-ID: <17565.1480077303@warthog.procyon.org.uk>
References: <CAKv+Gu_d5+Kvo7Tptnpg7kfjpqxhQ3a3nsQ0Ufsm6rBOFry+mQ@mail.gmail.com>
 <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk>
 <147990565051.7576.9673287945782426886.stgit@warthog.procyon.org.uk>
 <1480016487.2444.18.camel@HansenPartnership.com>
 <15173.1480066220@warthog.procyon.org.uk>
 <CAKv+Gu_JxNLDjaK5jGbX9ACzM0uHJYMOFx7XDo4t7DtBMtFRGA@mail.gmail.com>
 <16661.1480075392@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu_d5+Kvo7Tptnpg7kfjpqxhQ3a3nsQ0Ufsm6rBOFry+mQ@mail.gmail.com>
Content-ID: <17564.1480077303.1@warthog.procyon.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dhowells@redhat.com, linux-security-module <linux-security-module@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Yes. In pre-2.6, DeployedMode is not a reserved name, and so it may be
> possible for someone to slip in a DeployedMode=0 on a secure boot
> enabled system to trick the kernel into thinking lockdown should be
> disabled.

How does one get the version number?  Unfortunately, searching the document
for 'version' doesn't help as every page has that in the footer:-/

> > +               if (val == 1)
> > +                       return 0;
> 
> I think the logic is the wrong way around here. Secure Boot is enabled
> if SecureBoot=1 and SetupMode=0, unless DeployedMode=0. So you should
> return 0 here if val == 0, but only when running on 2.6 or later.

Good point.

David
