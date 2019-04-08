From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
Date: Mon, 8 Apr 2019 10:20:27 +0100
Message-ID: <1a77f587-3538-441f-c6c1-8e56fb65d855@arm.com>
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com>
 <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com>
 <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-efi <linux-efi@vger.kernel.org>, Steve McIntyre <steve.mcintyre@linaro.org>, Russell King <linux@armlinux.org.uk>, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

On 4/7/19 7:19 PM, Ard Biesheuvel wrote:
> Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
> v6. Would reading back SCTLR suffice?


I think instr_sync macro should do the trick.

Cheers
Vladimir
