From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Sat, 22 Apr 2017 18:45:47 -0700
Message-ID: <20170423014546.GA2704@dhcp-whq-twvpn-1-vpnpool-10-159-153-149.vpn.oracle.com>
References: <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon>
 <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com>
 <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org>
 <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
 <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com>
 <20170410165328.GA5248@red-moon>
 <CAKv+Gu-AN-OwnAJG5dt0Qg4GU8HxZBowTSA0H3LhNA3nHfrsQg@mail.gmail.com>
 <CAKv+Gu9dS4OhLbBw59yKYQmoJ8SpFexzk9yH=XfXnzn8NJ4mcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9dS4OhLbBw59yKYQmoJ8SpFexzk9yH=XfXnzn8NJ4mcg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>, Lukas Wunner <lukas@wunner.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 10, 2017 at 06:29:27PM +0100, Ard Biesheuvel wrote:
>  /*
> @@ -208,8 +208,8 @@ struct pci_bus *pci_acpi_scan_root(struct
> acpi_pci_root *root)
>         if (!bus)
>                 return NULL;
> 
> -       pci_bus_size_bridges(bus);
> -       pci_bus_assign_resources(bus);
> +       pci_assign_unassigned_root_bus_resources(bus);
> +       pci_bus_claim_resources(bus);
> 
>         list_for_each_entry(child, &bus->children, node)
>                 pcie_bus_configure_settings(child);
>

looks like those two lines are reversed. you should use:
                pcibios_resource_survey_bus(bus);
                pci_assign_unassigned_root_bus_resources(bus);

please check x86 pcibios_resource_survey_bus() definition in
	arch/x86/pci/i386.c

but pci_bus_claim_resources() should work too.

Yinghai
