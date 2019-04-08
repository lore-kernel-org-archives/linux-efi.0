From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
Date: Mon, 8 Apr 2019 23:38:59 +0200
Message-ID: <CAKv+Gu9dF-m_qjwJhDv656UGv9dQME=646TN55MUEB6Njwv-qQ@mail.gmail.com>
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com>
 <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com>
 <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
 <1a77f587-3538-441f-c6c1-8e56fb65d855@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1a77f587-3538-441f-c6c1-8e56fb65d855@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Steve McIntyre <steve.mcintyre@linaro.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 8 Apr 2019 at 11:20, Vladimir Murzin <vladimir.murzin@arm.com> wrote:
>
> On 4/7/19 7:19 PM, Ard Biesheuvel wrote:
> > Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
> > v6. Would reading back SCTLR suffice?
>
>
> I think instr_sync macro should do the trick.
>

This code should run on v7 when compiled for v6, and instr_sync uses
the CP15 ISB in that case, which we cannot use since that is what we
are enabling in the first place.

I'll go with Marc's suggestion, which should work in all cases
(although it may require a .arch directive to ensure the isb is
accepted)
