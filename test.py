import os

import torch
import torch.nn as nn


class MLP(nn.Module):
    def __init__(self, in_dim: int = 16, hidden_dim: int = 32, out_dim: int = 4):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(in_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, out_dim),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.net(x)


def main():
    torch.manual_seed(int(os.environ.get("SEED", 0)))
    device = (
        "cuda"
        if torch.cuda.is_available()
        else ("mps" if torch.backends.mps.is_available() else "cpu")
    )

    model = MLP().to(device)
    model.eval()

    x = torch.randn(8, 16, device=device)
    with torch.no_grad():
        y = model(x)

    print(f"device: {device}")
    print(f"input shape:  {tuple(x.shape)}")
    print(f"output shape: {tuple(y.shape)}")
    print(y)


if __name__ == "__main__":
    main()
