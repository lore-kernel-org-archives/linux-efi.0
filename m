From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] efi: Get the secure boot status [ver #3]
Date: Fri, 25 Nov 2016 16:50:35 +0000
Message-ID: <7005.1480092635@warthog.procyon.org.uk>
References: <31374.1480078855@warthog.procyon.org.uk> <CAKv+Gu9c-C2uXZ0fVatCM8ffXJZDgjBcDb_T0nsFecGqgrF11Q@mail.gmail.com> <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk> <147990565051.7576.9673287945782426886.stgit@warthog.procyon.org.uk> <1480016487.2444.18.camel@HansenPartnership.com> <15173.1480066220@warthog.procyon.org.uk> <CAKv+Gu_JxNLDjaK5jGbX9ACzM0uHJYMOFx7XDo4t7DtBMtFRGA@mail.gmail.com> <16661.1480075392@warthog.procyon.org.uk> <CAKv+Gu_d5+Kvo7Tptnpg7kfjpqxhQ3a3nsQ0Ufsm6rBOFry+mQ@mail.gmail.com> <17565.1480077303@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <31374.1480078855@warthog.procyon.org.uk>
Content-ID: <7004.1480092635.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
Cc: dhowells@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Lukas Wunner <lukas@wunner.de>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +	/* UEFI-2.6 requires DeployedMode to be 1. */
> +	if (sys_table_arg->hdr.revision == EFI_2_60_SYSTEM_TABLE_REVISION) {

Actually, I suspect that this should be '>='.

David
