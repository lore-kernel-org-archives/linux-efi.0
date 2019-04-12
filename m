From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efi/arm: enable CP15 DMB instructions before cleaning
 the cache
Date: Fri, 12 Apr 2019 14:21:47 -0700
Message-ID: <CAKv+Gu_4bNq8D4dRDB=qgcngpXoJNCOz5DN=w-A21cW8swCdQw@mail.gmail.com>
References: <20190409164220.5993-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_Fj9BacvCwu3XdWgE_i4EZWpTAp2Jjhj4DGMzC0bo1nA@mail.gmail.com>
 <20190412205834.aok6v3fnjaxl27qt@shell.armlinux.org.uk>
 <CAKv+Gu_vejJz0Gh4hz75yvUcbpiDGyA0KjUS=hSgMmMv_Z1dOg@mail.gmail.com>
 <20190412212055.lgsnjle3x75gu22m@shell.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190412212055.lgsnjle3x75gu22m@shell.armlinux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Vladimir Murzin <vladimir.murzin@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 12 Apr 2019 at 14:21, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 12, 2019 at 02:00:16PM -0700, Ard Biesheuvel wrote:
> > If I use the forgotten password feature, it tells me
> >
> > """
> > The email address you provided (ard.biesheuvel@linaro.org) is not
> > valid. Please try again.
> > """
>
> Fixed, consequence of the upgrades back in January, requiring a
> change to the regular expression system, which caused my simple
> fixups to then generate an invalid RE.  You should have received
> the new password as a result of my testing.
>
> Thanks for reporting the problem - that's the only way problems
> get fixed!
>

Indeed. Thanks for solving it so quickly.
